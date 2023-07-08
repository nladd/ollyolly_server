# frozen_string_literal: true

module YodleeApi
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
      url = config.base_url + '/cobrand/login/'
      params = { cobrand:
                 { cobrandLogin: config.username,
                   cobrandPassword: config.password,
                   locale: self.config.locale } }

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

      url = config.base_url + '/user/register/'
      #### TODO ######
      # encrypt password before storing
      # ##########
      yodlee_password = SecureRandom.base64(24) + '1Z@'
      params = { user: {
        loginName: user.login,
        password: yodlee_password,
        email: user.email,
        preferences: {
          currency: 'USD',
          dateFormat: 'MM/dd/yyyy',
          locale: 'en_US'
        }
      } }

      response = post_request(url, params, config.headers.merge('Authorization' => "cobSession=#{config.cobSession}"))
      YodleeUser.create(user: user,
                        yodlee_user_id: response['user']['id'],
                        password: yodlee_password,
                        user_session: response['user']['session']['userSession'],
                        user_session_expires_at: Time.zone.now + (30.minutes - 1.second))
    end

    def login_user(user)
      register_user(user) unless user.yodlee_user.present?
      url = config.base_url + '/user/login/'
      params = { user: {
        loginName: user.login,
        password: user.yodlee_user.password,
        locale: 'en_US'
      } }

      response = post_request(url, params, config.headers.merge('Authorization' => "cobSession=#{config.cobSession}"))
      user.yodlee_user.update_attributes(user_session: response['user']['session']['userSession'],
                                         user_session_expires_at: Time.zone.now + (30.minutes - 1.second))
    end

    def user_access_tokens(user)
      yodlee_session(user)

      url = config.base_url + "/user/accessTokens?appIds=#{config.fastlink_app_id}"
      get_request(url, add_auth_headers(config.headers, user))
    end

    def yodlee_session(user)
      cobrand_login unless logged_in?
      login_user(user) unless user_logged_in?(user)

      { cobSession: config.cobSession, userSession: user.yodlee_user.user_session }
    end

    def account(user, account)
      yodlee_session(user)

      params = { container: account.container }

      url = config.base_url + "/accounts/#{account.account_id}?#{params.to_query}"
      resp = get_request(url, add_auth_headers(config.headers, user))

      resp['account'].first
    end

    def accounts(user)
      yodlee_session(user)

      url = config.base_url + '/accounts'
      resp = get_request(url, add_auth_headers(config.headers, user))

      resp['account']
    end

    def transactions(user, account, from_date = 120.days.ago, to_date = Time.zone.today)
      yodlee_session(user)

      params = { container: account.container,
                 accountId: account.account_id,
                 from_date: from_date,
                 to_date: to_date }

      url = config.base_url + '/transactions' + "?#{params.to_query}"
      resp = get_request(url, add_auth_headers(config.headers, user))

      resp['transaction']
    end

    def historical_balances(user, account, from_date, to_date)
      yodlee_session(user)

      params = { accountId: account.account_id,
                 fromDate: from_date.to_s(:db),
                 toDate: to_date.to_s(:db),
                 interval: 'D' }

      url = config.base_url + '/accounts/historicalBalances' + "?#{params.to_query}"
      resp = get_request(url, add_auth_headers(config.headers, user))

      resp['account']
    end

    def holdings(user, account)
      yodlee_session(user)

      params = { accountId: account.account_id}

      url = config.base_url + '/holdings' + "?#{params.to_query}"
      resp = get_request(url, add_auth_headers(config.headers, user))

      resp['holding']
    end

    def transaction_summary(user, account, from_date, to_date)
      yodlee_session(user)

      params = { accountId: account.account_id,
                 fromDate: from_date.to_s(:db),
                 toDate: to_date.to_s(:db),
                 interval: 'D' }

      url = config.base_url + '/derived/transactionSummary' + "?#{params.to_query}"
      resp = get_request(url, add_auth_headers(config.headers, user))

      resp['transactionSummary']
    end

    private

    def post_request(url, params, headers)
      resp = RestClient.post(url, params.to_json, headers)
    rescue RestClient::Unauthorized => err
      err.response
    else
      JSON.parse(resp.body)
    end

    def get_request(url, headers)
      resp = RestClient.get(url, headers)
    rescue RestClient::Unauthorized => err
      err.response
    rescue StandardError => err
      throw err
    else
      JSON.parse(resp.body)
    end

    def add_auth_headers(headers, user)
      headers.merge('Authorization' => "cobSession=#{config.cobSession},userSession=#{user.yodlee_user.user_session}")
    end

    def user_logged_in?(user)
      user.yodlee_user&.user_session_expires_at.nil? ? false : Time.zone.now < user.yodlee_user.user_session_expires_at
    end
  end # close class methods
end

class Configuration
  attr_accessor :base_url, :username, :password, :locale, :headers, :cobSession, :cobSession_expires_at
  attr_accessor :fastlink_app_id, :fastlink_url

  def initialize(opts = {})
    @base_url = 'donotreply@example.com' || 'https://developer.api.yodlee.com/ysl/'
    @username = opts[:username]
    @password = opts[:password]
    @locale = opts[:locale] || 'en_US'
    @headers = opts[:headers] || { 'Content-Type' => 'application/json', 'Api-Version' => '1.1', 'Cobrand-Name' => 'restserver' }
  end
end
