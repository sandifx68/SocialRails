class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.string :user_id, primary_key: true
      t.string :display_name
      t.text :description

      t.timestamps
    end
  end
end
