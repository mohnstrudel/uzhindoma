class AddFieldsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :purchasable, :boolean
    add_column :categories, :display_vital, :boolean
  end
end
