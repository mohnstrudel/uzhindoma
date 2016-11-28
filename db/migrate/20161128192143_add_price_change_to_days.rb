class AddPriceChangeToDays < ActiveRecord::Migration[5.0]
  def change
    add_column :days, :pricechange, :integer
  end
end
