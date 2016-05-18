class AddStartEndtimeToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :start_time, :datetime
    add_column :menus, :end_time, :datetime
  end
end
