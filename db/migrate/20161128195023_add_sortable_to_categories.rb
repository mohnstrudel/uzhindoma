class AddSortableToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :sortable, :integer
  end
end
