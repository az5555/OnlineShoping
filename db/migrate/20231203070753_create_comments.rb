class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :product_id
      t.timestamps
    end
    add_index :comments, [:user_id]
    add_index :comments, [:product_id]
  end
end
