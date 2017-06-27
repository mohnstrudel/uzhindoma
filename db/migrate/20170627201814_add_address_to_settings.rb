class AddAddressToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :address, :text
  end
end
