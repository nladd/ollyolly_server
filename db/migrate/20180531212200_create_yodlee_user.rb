# frozen_string_literal: true

class CreateYodleeUser < ActiveRecord::Migration[5.2]
  def up
    unless table_exists?(:yodlee_users)
      create_table(:yodlee_users) do |t|
        t.integer :yodlee_user_id
        t.string :password
        t.string :user_session
        t.datetime :user_session_expires_at

        t.integer :user_id

        t.timestamps
      end
      add_index :yodlee_users, :user_id
      add_index :yodlee_users, :yodlee_user_id
    end
  end

  def down
    drop_table(:yodlee_users) if table_exists?(:yodlee_users)
  end
end
