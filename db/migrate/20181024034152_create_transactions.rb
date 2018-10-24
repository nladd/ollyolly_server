class CreateTransactions < ActiveRecord::Migration[5.2]
  def up
    unless table_exists?(:transactions)
      create_table :transactions do |t|
        t.integer :transaction_id
        t.string :base_type
        t.string :transaction_type
        t.date :transaction_date
        t.string :status
        t.string :symbol
        t.float :twr

        t.integer :account_id
        t.integer :user_id

        t.timestamps
      end
      add_index :transactions, :account_id
      add_index :transactions, :user_id
      add_index :transactions, :transaction_id
    end
  end

  def down
    drop_table(:transactions) if table_exists?(:transactions)
  end
end
