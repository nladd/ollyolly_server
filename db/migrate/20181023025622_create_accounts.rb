# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[5.2]
  def up
    unless table_exists?(:accounts)
      create_table :accounts do |t|
        t.string :account_name
        t.string :account_type
        t.string :account_status
        t.string :provider_id
        t.integer :provider_account_id
        t.string :container
        t.integer :account_id
        t.string :provider_name

        t.integer :user_id
        t.integer :provider_id

        t.timestamps
      end
      add_index :accounts, :user_id
      add_index :accounts, :provider_id
      add_index :accounts, :account_id
      add_index :accounts, :provider_account_id
    end
  end

  def down
    drop_table(:accounts) if table_exists?(:accounts)
  end
end
