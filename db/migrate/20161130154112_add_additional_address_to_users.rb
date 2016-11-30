class AddAdditionalAddressToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :additional_address, :string
  end
end
