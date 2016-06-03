class AddChangeToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :change_from, :string
    add_column :menus, :change_to, :string
  end
end
