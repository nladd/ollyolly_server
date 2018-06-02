class CreateYodleeUser < ActiveRecord::Migration[5.2]
  def change
    create_table(:yodlee_users) do |t|
      t.integer :user_id
      t.integer :yodlee_user_id
      t.string :password
      t.string :user_session
      t.datetime :user_session_expires_at

      t.timestamps
    end

    add_index :yodlee_users, :user_id, unique: true
    add_index :yodlee_users, :yodlee_user_id
  end
end
