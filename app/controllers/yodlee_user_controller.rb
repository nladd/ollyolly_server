
class YodleeUserController < ApplicationController

  def accounts
    accounts = YodleeApi.accounts(current_user)

    render json: accounts
  end

end
