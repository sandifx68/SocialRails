class CreateFriendships < ActiveRecord::Migration[8.0]
  def change
    create_table :friendships do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :friend, null: false, foreign_key: { to_table: :users }
      t.boolean :accepted, default: false, null: false

      t.timestamps
    end

    add_index :friendships, [ :user_id, :friend_id ], unique: true
  end
end
