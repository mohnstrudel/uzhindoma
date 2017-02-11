class AddTitleToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :title, :string
  end
end
