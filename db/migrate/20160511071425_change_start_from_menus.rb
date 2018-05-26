class ChangeStartFromMenus < ActiveRecord::Migration[4.2]
  def change
  	rename_column :menus, :start, :daterange
  end
end
