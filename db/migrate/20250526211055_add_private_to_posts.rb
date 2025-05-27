class AddPrivateToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :private, :boolean, null: false, default: true
  end
end
