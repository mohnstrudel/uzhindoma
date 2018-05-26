class AddHotpicToMenus < ActiveRecord::Migration[4.2]
  def change
    add_column :menus, :hotpic, :string
  end
end
