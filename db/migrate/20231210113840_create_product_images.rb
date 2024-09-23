class CreateProductImages < ActiveRecord::Migration[7.1]
  def change
    create_table :product_images do |t|
      t.belongs_to :product
      t.integer :weight, default: 0
      t.timestamps
    end
    add_index :product_images, [:product_id, :weight]
  end
end
