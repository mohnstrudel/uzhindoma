class AddDeliveryRegionToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :delivery_region, :string
  end
end
