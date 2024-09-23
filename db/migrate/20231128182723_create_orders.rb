class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :user_name
      t.integer :product_id
      t.string :product_name
      t.integer :amount
      t.datetime :pay_time
      t.decimal :total_money, precision: 8, scale: 2
      t.timestamps
      t.integer :status, default: 0
    end


    add_index :orders, [:user_id]
  end
end
