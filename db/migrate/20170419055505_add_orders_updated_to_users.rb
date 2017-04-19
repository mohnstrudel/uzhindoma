class AddOrdersUpdatedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :orders_updated, :boolean, default: false
  end
end
