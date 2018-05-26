class AddChangeToMenus < ActiveRecord::Migration[4.2]
  def change
    add_column :menus, :change_from, :string
    add_column :menus, :change_to, :string
  end
end
