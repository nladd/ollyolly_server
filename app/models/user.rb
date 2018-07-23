class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :email

  has_one :yodlee_user

  before_create :generate_login
  after_create :register_yodlee_user

  private

  def generate_login
    self.login = SecureRandom.base64(16)
  end

  def register_yodlee_user
    # TODO: Uncomment when we have a real yodlee account
    # YodleeApi.register_user(self)
  end
end
