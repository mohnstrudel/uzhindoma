class AddAvatarToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :avatar, :string
    add_column :users, :phone, :string
  end
end
