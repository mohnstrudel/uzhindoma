class AddDeliveryTimeframeToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :delivery_timeframe, :string
  end
end
