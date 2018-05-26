class AddCategoryToOrders < ActiveRecord::Migration[4.2]
  def change
    add_reference :orders, :category, index: true, foreign_key: true
  end
end
