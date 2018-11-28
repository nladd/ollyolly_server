# frozen_string_literal: true

class FastlinkController < ActionController::Base
#  before_action :authenticate_user!

  def fastlink
    @current_user = User.first
    resp = YodleeApi.user_access_tokens(current_user)
    @access_tokens = resp['user']['accessTokens'].first

    request.format = 'html'
    respond_to do |format|
      format.html do
        render 'fastlink/fastlink'
      end
    end
  end
end
