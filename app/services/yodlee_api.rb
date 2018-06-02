
module YodleeApi

  FASTLINK_APP_ID = '10003600'

  class << self
    attr_accessor :config

    def configure
      self.config ||= Configuration.new
      yield(config)
    end

    def configured?
      config.present?
    end

    def cobrand_login
      url = config.base_url + 'cobrand/login/'
      params = { cobrand:
                 {cobrandLogin: config.username,
                  cobrandPassword: config.password,
                  locale: self.config.locale}
      }

      response = post_request(url, params, config.headers)

      config.cobSession = response['session']['cobSession']
      config.cobSession_expires_at = Time.zone.now + (100.minutes - 1.second)
    end

    def logged_in?
      return false unless configured?
      self.config.cobSession_expires_at.nil? ? false : Time.zone.now < self.config.cobSession_expires_at
    end

    def register_user(user)
      cobrand_login unless logged_in?

      url = config.base_url + 'user/register/'
      #### TODO ######
      # encrypt password before storing
      # ##########
      yodlee_password = SecureRandom.base64(24) + '1Z@'
      params = { user: {
        loginName: user.login,
        password: yodlee_password,
        email: user.email,
        preferences: {
          currency: "USD",
          dateFormat: "MM/dd/yyyy",
          locale: "en_US" }
        }
      }

      response = post_request(url, params, config.headers.merge('Authorization' => "cobSession=#{config.cobSession}"))
      YodleeUser.create(user: user,
                        yodlee_user_id: response['user']['id'],
                        password: yodlee_password,
                        user_session: response['user']['session']['userSession'],
                        user_session_expires_at: Time.zone.now + (30.minutes - 1.second))
    end

    def login_user(user)
      register_user(user) unless user.yodlee_user.present?
      url = config.base_url + 'user/login/'
      params = { user: {
        loginName: user.login,
        password: user.yodlee_user.password,
        locale: 'en_US'
        }
      }

      response = post_request(url, params, config.headers.merge('Authorization' => "cobSession=#{config.cobSession}"))
      user.yodlee_user.update_attributes(user_session: response['user']['session']['userSession'],
                                         user_session_expires_at: Time.zone.now + (30.minutes - 1.second))
    end

    def user_logged_in?(user)
      user.yodlee_user&.user_session_expires_at.nil? ? false : Time.zone.now < user.yodlee_user.user_session_expires_at
    end

    def user_access_tokens(user)
      cobrand_login unless logged_in?
      login_user(user) unless user_logged_in?(user)

      url = config.base_url + "user/accessTokens?appIds=#{FASTLINK_APP_ID}"

      get_request(url, add_auth_headers(config.headers, user))
    end

    private

    def post_request(url, params, headers)
      begin
        resp = RestClient.post(url, params.to_json, headers)
      rescue RestClient::Unauthorized => err
        err.response
      rescue StandardError => err
        throw err
      else
        JSON.parse(resp.body)
      end
    end

    def get_request(url, headers)
      begin
        resp = RestClient.get(url, headers)
      rescue RestClient::Unauthorized => err
        err.response
      rescue StandardError => err
        throw err
      else
        JSON.parse(resp.body)
      end
    end

    def add_auth_headers(headers, user)
      headers.merge({'Authorization' => "cobSession=#{config.cobSession},userSession=#{user.yodlee_user.user_session}"})
    end
  end


end

class Configuration
  attr_accessor :base_url, :username, :password, :locale, :headers, :cobSession, :cobSession_expires_at

  def initialize(opts = {})
    @base_url = 'donotreply@example.com' || 'https://developer.api.yodlee.com/ysl/'
    @username = opts[:username]
    @password = opts[:password]
    @locale = opts[:locale] || 'en_US'
    @headers = opts[:headers] || {'Content-Type' => 'application/json', 'Api-Version' => '1.1', 'Cobrand-Name' => 'restserver'}
  end
end
