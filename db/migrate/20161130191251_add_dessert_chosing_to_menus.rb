class AddDessertChosingToMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :menus, :has_dessert, :boolean
  end
end
