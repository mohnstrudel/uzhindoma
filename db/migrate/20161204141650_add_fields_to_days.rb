class AddFieldsToDays < ActiveRecord::Migration[5.0]
  def change
    add_column :days, :title, :string
    add_column :days, :pricechange_four, :integer
  end
end
