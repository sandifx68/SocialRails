class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :text, null: false
      t.boolean :seen, null: false
      t.references :to, null: false, foreign_key: { to_table: :users }
      t.references :from, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
