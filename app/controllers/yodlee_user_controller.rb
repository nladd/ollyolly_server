# frozen_string_literal: true

class YodleeUserController < ApplicationController
  before_action :authenticate_user!

  def accounts
    accounts = YodleeApi.accounts(current_user)

    # TODO: Put this in a background job
    current_user.save_accounts(accounts)

    render json: accounts.to_json
  end

  def transactions
    if account = current_user.accounts.find_by(account_id: params[:account_id])
      transactions = YodleeApi.transactions(current_user, account)

      account.save_transactions(transactions)

      render json: transactions.to_json
    else
      render plain: 'AccountNotFound', status: 404
    end
  end
end
