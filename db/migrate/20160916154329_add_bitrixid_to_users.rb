class AddBitrixidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :bitrix_id, :string
    add_column :users, :integer, :string
  end
end
