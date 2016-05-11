class ChangeStartFromMenus < ActiveRecord::Migration
  def change
  	rename_column :menus, :start, :daterange
  end
end
