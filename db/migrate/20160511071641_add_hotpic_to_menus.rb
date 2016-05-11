class AddHotpicToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :hotpic, :string
  end
end
