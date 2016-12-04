class AddTitleToPersonamount < ActiveRecord::Migration[5.0]
  def change
    add_column :personamounts, :title, :string
  end
end
