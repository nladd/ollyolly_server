# frozen_string_literal: true

class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :email

  has_one :yodlee_user, dependent: :destroy

  has_many :accounts, dependent: :destroy
  has_many :transactions, dependent: :destroy

  before_create :generate_login
  after_create :register_yodlee_user

  def save_accounts(accounts)
    accounts.each do |account|
      next if Account.exists?(account_id: account['account_id'], user_id: id)

      self.accounts << Account.create(account_name: account['accountName'],
                                      account_type: account['accountType'],
                                      account_status: account['accountStatus'],
                                      provider_id: account['providerId'],
                                      provider_account_id: account['providerAccountId'],
                                      container: account['CONTAINER'],
                                      account_id: account['id'],
                                      provider_name: account['providerName'])
    end
  end

  private

  def generate_login
    self.login = SecureRandom.base64(16)
  end

  def register_yodlee_user
    # TODO: Uncomment when we have a real yodlee account
    # YodleeApi.register_user(self)
  end
end
