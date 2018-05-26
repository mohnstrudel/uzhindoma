class AddOrdertypeToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :order_type, :string
    add_column :orders, :menu_type, :string
  end
end
