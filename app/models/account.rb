# frozen_string_literal: true

class Account < ApplicationRecord

  belongs_to :user

  has_many :transactions, dependent: :destroy

  def save_transactions(transactions)
    transactions.each do |transaction|
      next if Transaction.exists?(transaction_id: transaction['id'])

      self.transactions << Transaction.create(transaction_id: transaction['id'],
                                         base_type: transaction['baseType'],
                                         transaction_type: transaction['type'],
                                         transaction_date: transaction['transactionDate'],
                                         status: transaction['status'],
                                         symbol: transaction['symbol'],
                                         account_id: id,
                                         user_id: user_id)

    end

  end


end
