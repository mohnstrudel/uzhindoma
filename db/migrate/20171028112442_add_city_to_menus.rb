class AddCityToMenus < ActiveRecord::Migration[5.1]
  def change
    add_reference :menus, :city, index: true, foreign_key: true
  end
end
