
class YodleeUser < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
