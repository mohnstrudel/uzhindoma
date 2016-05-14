class AddCustomfieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :menu_amount, :integer
    add_column :orders, :person_amount, :integer
    add_column :orders, :change, :boolean
  end
end
