class AddCheckboxesToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :display_persons, :boolean
    add_column :categories, :display_days, :boolean
    add_column :categories, :display_description, :boolean
  end
end
