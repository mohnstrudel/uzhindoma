class AddPromocodeToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :promocode, :string
  end
end
