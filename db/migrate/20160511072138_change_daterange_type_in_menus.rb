class ChangeDaterangeTypeInMenus < ActiveRecord::Migration
  def change
  	change_column :menus, :daterange, :string
  end
end
