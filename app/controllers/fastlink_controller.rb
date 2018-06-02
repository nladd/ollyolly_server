class FastlinkController < ActionController::Base

  def fastlink
    @user = User.first
    resp = YodleeApi.user_access_tokens(@user)
    @access_tokens = resp['user']['accessTokens'].first

    respond_to do |format|
      format.html {
        puts "rendering html"
        render 'fastlink/fastlink'
      }
    end
  end

end
