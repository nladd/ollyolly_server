# frozen_string_literal: true

class Transaction < ApplicationRecord

  belongs_to :user
  belongs_to :account

  before_validation :transaction_of_interest?
  validates_presence_of :symbol

  after_create :calculate_balances, :calculate_twr

  private

  def calculate_balances
    return unless TransactionGroups::TRANSACTIONS_OF_INTEREST.include?(transaction_type)
    holdings = YodleeApi.holdings(user, account)
    holdings.keep_if {|holding| holding['symbol'] == self.symbol}

    return unless holding = holdings.first
    sum_quantity_future_tx = Transaction.where(account_id: account_id, symbol: symbol)
      .where(['created_date > ? AND transaction_date >= ?', created_date, transaction_date])
      .sum(:quantity).round(3)

    quantity_after_tx = sum_quantity_future_tx > 0 ? holding['quantity'] - sum_quantity_future_tx : holding['quantity']
    update_attributes(ending_balance: quantity_after_tx * price, beginning_balance: (quantity_after_tx - quantity)  * price)
  end

  def calculate_twr
    TwrCalculator.calculate_transaction_twr(self)
  end

  def transaction_of_interest?
    throw :abort unless TransactionGroups::TRANSACTIONS_OF_INTEREST.include?(transaction_type)
  end
end
