class CreateDinnerAmountOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :dinner_amount_options do |t|
      t.integer :day_number
      t.float :pricechange
      t.belongs_to :personamount, foreign_key: true

      t.timestamps
    end
  end
end
