# frozen_string_literal: true

class TransactionGroups

  CREDIT_TRANSACTIONS = [ TransactionTypes::BUY,
                        TransactionTypes::CONTRIBUTION_401K,
                        TransactionTypes::EMPLOYER_CONTRIBUTION_401K,
                        TransactionTypes::PLAN_CONTRIBUTION_529,
                        TransactionTypes::ADJUSTED_BUY,
                        TransactionTypes::AUTOMATIC_INVESTMENT,
                        TransactionTypes::BUY_ACCRUED_INTEREST,
                        TransactionTypes::BUY_OPTION,
                        TransactionTypes::BUY_TO_CLOSE,
                        TransactionTypes::BUY_TO_COVER,
                        TransactionTypes::BUY_TO_OPEN,
                        TransactionTypes::CAPITAL_GAINS_REINVESTED,
                        TransactionTypes::DIVIDEND_REINVESTMENT,
                        TransactionTypes::INTEREST_REINVESTMENT,
                        TransactionTypes::IRA_CONTRIBUTION,
                        TransactionTypes::REINVEST_LONG_TERM_CAPITAL_GAINS,
                        TransactionTypes::REINVEST_SHORT_TERM_CAPITAL_GAINS,
                        TransactionTypes::ROTH_CONTRIBUTION,
                        TransactionTypes::TRANSFER_SHARES_IN]

  DEBIT_TRANSACTIONS = [ TransactionTypes::SELL,
                        TransactionTypes::ACCOUNT_FEE,
                        TransactionTypes::ACCOUNT_MAINTENANCE_FEE,
                        TransactionTypes::ADJUSTED_SELL,
                        TransactionTypes::ADMINISTRATIVE_FEE,
                        TransactionTypes::ATM_FEE,
                        TransactionTypes::ATM_WITHDRAWAL,
                        TransactionTypes::ATM_WITHDRAWAL_FEE,
                        TransactionTypes::FUND_EXPENSE,
                        TransactionTypes::IRA_DISTRIBUTION,
                        TransactionTypes::IRA_NON_QUALIFIED_DISTRIBUTION,
                        TransactionTypes::LONG_TERM_CAPITAL_GAINS_DISTRIBUTION,
                        TransactionTypes::MARGIN_INTEREST_EXPENSE,
                        TransactionTypes::MISCELLANEOUS_EXPENSE,
                        TransactionTypes::NSF_FEE,
                        TransactionTypes::ORDER_OUT_FEE,
                        TransactionTypes::SELL_ACCRUED_INTEREST,
                        TransactionTypes::SELL_OPTION,
                        TransactionTypes::SELL_TO_CLOSE,
                        TransactionTypes::SELL_TO_OPEN,
                        TransactionTypes::SHORT_SELL,
                        TransactionTypes::WIRE_FEE,
                        TransactionTypes::TRANSFER_SHARES_OUT]

  TRANSACTIONS_OF_INTEREST = CREDIT_TRANSACTIONS.concat(DEBIT_TRANSACTIONS)

end
