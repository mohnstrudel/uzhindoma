class CreateMenurecipes < ActiveRecord::Migration
  def change
    create_table :menurecipes do |t|
      t.references :menu, index: true, foreign_key: true
      t.references :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
