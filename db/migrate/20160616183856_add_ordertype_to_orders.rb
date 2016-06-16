class AddOrdertypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_type, :string
    add_column :orders, :menu_type, :string
  end
end
