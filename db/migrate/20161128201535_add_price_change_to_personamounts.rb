class AddPriceChangeToPersonamounts < ActiveRecord::Migration[5.0]
  def change
    add_column :personamounts, :pricechange, :integer
  end
end
