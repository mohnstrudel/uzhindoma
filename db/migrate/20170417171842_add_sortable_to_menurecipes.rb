class AddSortableToMenurecipes < ActiveRecord::Migration[5.0]
  def change
    add_column :menurecipes, :sortable, :integer
  end
end
