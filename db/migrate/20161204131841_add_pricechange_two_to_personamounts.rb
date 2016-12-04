class AddPricechangeTwoToPersonamounts < ActiveRecord::Migration[5.0]
  def change
    add_column :personamounts, :pricechange_life, :integer
  end
end
