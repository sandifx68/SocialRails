class AddUserId < ActiveRecord::Migration[8.0]
  def change
    # Remove the existing primary key
    execute "ALTER TABLE users DROP CONSTRAINT users_pkey"

    add_column :users, :id, :primary_key
  end
end
