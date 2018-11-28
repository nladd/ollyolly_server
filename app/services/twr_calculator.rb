# frozen_string_literal: true

class TwrCalculator

  class << self

    def calculate_twr_per_transaction(user, transactions)
      return if transactions.empty?
      raise "All transactions must be from the same account" if transactions.map(&:account_id).uniq.size > 1

      holdings = YodleeApi.holdings(user, transactions.first.account)

      holdings.each do |holding|

        relevant_transactions = transactions.sort_by(&:transaction_date).select{|tx| tx.symbol == holding['symbol']}
        tx_quantity = relevant_transactions.map(&:quantity).sum

        quantity = holding['quantity'] - tx_quantity
        first_tx = relevant_transactions.shift

        initial_balance = first_tx.price * quantity + first_tx.price * first_tx.quantity
        quantity = quantity + first_tx.quantity

        relevant_transactions.each do |transaction|
          quantity = quantity + transaction.quantity
          end_balance = quantity * transaction.price
          cash_flow = transaction.price * transaction.quantity

          twr = (end_balance - (initial_balance + cash_flow)) / (initial_balance + cash_flow)
          transaction.update_attributes(twr: twr)

          initial_balance = end_balance
        end
      end
    end

    def calculate_transaction_twr(tx)
      if previous_tx = Transaction.where(user_id: tx.user_id, account_id: tx.account_id, symbol: tx.symbol)
        .where(['id <> ? AND transaction_date <= ?', tx.id, tx.transaction_date])
        .order('transaction_date DESC, created_date DESC').first

        initial_balance = previous_tx.ending_balance
        ending_balance = tx.ending_balance
        cash_flow = tx.quantity * tx.price
        cash_flow *= -1 if tx.base_type == TransactionTypes::DEBIT

        twr = (ending_balance - (initial_balance + cash_flow)) / (initial_balance + cash_flow)
        tx.update_attributes(twr: twr)
      end

    end

  end

end
