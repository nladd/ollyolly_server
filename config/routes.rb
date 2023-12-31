# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  get '/fastlink' => 'fastlink#fastlink'

  scope 'yodlee_user', controller: 'yodlee_user' do
    get '/accounts', action: :accounts
    get '/account/:account_id/transactions', action: :transactions
  end
end
