class FastlinkController < ActionController::Base
  #before_action :authenticate_user!

  def fastlink
    @user = User.first
    resp = YodleeApi.user_access_tokens(@user)
    @access_tokens = resp['user']['accessTokens'].first


    request.format = 'html'
    respond_to do |format|
      format.html {
        render 'fastlink/fastlink'
      }
    end
  end

end
