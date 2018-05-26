class RemoveFinishFromMenus < ActiveRecord::Migration[4.2]
  def change
    remove_column :menus, :finish, :datetime
  end
end
