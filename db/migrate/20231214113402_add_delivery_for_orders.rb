class AddDeliveryForOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :deliver_name, :string
    add_column :orders, :deliver_id, :integer
  end
end
