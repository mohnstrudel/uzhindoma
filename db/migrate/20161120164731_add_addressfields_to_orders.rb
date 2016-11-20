class AddAddressfieldsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :street, :string
    add_column :orders, :house_number, :string
    add_column :orders, :korpus, :string
    add_column :orders, :flat_number, :string
  end
end
