class AddPromocodeRefToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :promocode, foreign_key: true
  end
end
