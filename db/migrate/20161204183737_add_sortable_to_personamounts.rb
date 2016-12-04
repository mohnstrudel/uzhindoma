class AddSortableToPersonamounts < ActiveRecord::Migration[5.0]
  def change
    add_column :personamounts, :sortable, :integer
  end
end
