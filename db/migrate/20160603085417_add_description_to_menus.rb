class AddDescriptionToMenus < ActiveRecord::Migration[4.2]
  def change
    add_column :menus, :description, :text
  end
end
