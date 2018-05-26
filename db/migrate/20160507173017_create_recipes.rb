class CreateRecipes < ActiveRecord::Migration[4.2]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :description
      t.integer :calories
      t.integer :fat
      t.integer :carbohydrates

      t.timestamps null: false
    end
  end
end
