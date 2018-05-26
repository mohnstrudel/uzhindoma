class AddStartEndtimeToMenus < ActiveRecord::Migration[4.2]
  def change
    add_column :menus, :start_time, :datetime
    add_column :menus, :end_time, :datetime
  end
end
