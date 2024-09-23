class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :category_id
      t.integer :status, default: 1
      t.integer :count
      t.decimal :price, precision: 8, scale: 2
      t.decimal :price_before, precision: 8, scale: 2
      t.text :description
      t.datetime :add_timestamps
      t.timestamps
    end
    add_index :products, [:status, :category_id]
    add_index :products, [:category_id]
    add_index :products, [:name]
  end
end
