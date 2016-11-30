class AddPartialNamesToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :first_name, :string
    add_column :orders, :second_name, :string
  end
end
