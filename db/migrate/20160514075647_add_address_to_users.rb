class AddAddressToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :address, :text
  end
end
