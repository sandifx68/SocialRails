class AddLastEditedToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :last_edited, :datetime
  end
end
