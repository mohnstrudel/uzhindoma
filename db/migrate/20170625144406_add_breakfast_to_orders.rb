class AddBreakfastToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :add_breakfast, :boolean
  end
end
