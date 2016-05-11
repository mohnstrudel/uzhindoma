class RemoveFinishFromMenus < ActiveRecord::Migration
  def change
    remove_column :menus, :finish, :datetime
  end
end
