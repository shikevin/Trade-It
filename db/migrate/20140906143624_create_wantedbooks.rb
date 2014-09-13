class CreateWantedbooks < ActiveRecord::Migration
  def change
    create_table :wantedbooks do |t|
      t.string :content
      t.integer :user_id
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :wantedbooks, [:user_id, :created_at]
  end
end
