class AddTotalMoneyForUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :total_money, :integer, default: 0
  end
end
