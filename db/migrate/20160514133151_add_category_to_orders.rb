class AddCategoryToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :category, index: true, foreign_key: true
  end
end
