class AddPayedOnlineToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :payed_online, :boolean
  end
end
