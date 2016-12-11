class AddOrdersToPromocodes < ActiveRecord::Migration[5.0]
  def change
    add_reference :promocodes, :order, foreign_key: true
  end
end
