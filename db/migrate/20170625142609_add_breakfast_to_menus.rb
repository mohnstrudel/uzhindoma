class AddBreakfastToMenus < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :has_breakfast, :boolean
  end
end
