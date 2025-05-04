class AddUniqueConstraintToUserId < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :user_id, unique: true
  end
end
