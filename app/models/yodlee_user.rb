# frozen_string_literal: true

class YodleeUser < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
