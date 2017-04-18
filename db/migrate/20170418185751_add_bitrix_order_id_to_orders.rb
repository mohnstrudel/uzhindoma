class AddBitrixOrderIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :bitrix_order_id, :integer
  end
end
