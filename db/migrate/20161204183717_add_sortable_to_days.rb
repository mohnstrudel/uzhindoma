class AddSortableToDays < ActiveRecord::Migration[5.0]
  def change
    add_column :days, :sortable, :integer
  end
end
