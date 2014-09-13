class CreateSellingbooks < ActiveRecord::Migration
  def change
    create_table :sellingbooks do |t|
      t.string :content
      t.integer :user_id
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :sellingbooks, [:user_id, :created_at]
  end
end
