class ChangeDaterangeTypeInMenus < ActiveRecord::Migration[4.2]
  def change
  	change_column :menus, :daterange, :string
  end
end
