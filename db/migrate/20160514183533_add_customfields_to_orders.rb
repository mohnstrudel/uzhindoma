class AddCustomfieldsToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :menu_amount, :integer
    add_column :orders, :person_amount, :integer
    add_column :orders, :change, :boolean
  end
end
