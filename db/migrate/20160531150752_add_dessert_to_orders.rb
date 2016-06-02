class AddDessertToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :add_dessert, :boolean
  end
end
