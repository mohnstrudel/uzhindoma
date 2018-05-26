class AddDessertToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :add_dessert, :boolean
  end
end
