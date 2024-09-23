class AddWightForProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :weight, :integer, default: 0
  end
end
