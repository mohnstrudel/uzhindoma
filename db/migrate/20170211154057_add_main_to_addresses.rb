class AddMainToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :main, :boolean
  end
end
