class AddMenuIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :menu, index: true, foreign_key: true
  end
end
