class CreateMenus < ActiveRecord::Migration[4.2]
  def change
    create_table :menus do |t|
      t.references :category, index: true, foreign_key: true
      t.integer :price
      t.datetime :start
      t.datetime :finish

      t.timestamps null: false
    end
  end
end
