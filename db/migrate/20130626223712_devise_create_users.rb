class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :username
      t.integer :current_account_id
      t.timestamps
    end
    add_index :users, :username,                :unique => true
  end
end
