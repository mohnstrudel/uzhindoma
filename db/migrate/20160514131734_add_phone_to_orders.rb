class AddPhoneToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :phone, :string
  end
end
