class CreateBPersonamounts < ActiveRecord::Migration[5.1]
  def change
    create_table :b_personamounts do |t|
      t.integer :value
      t.string :wordvalue
      t.integer :pricechange
      t.string :title
      t.integer :pricechange_life
      t.integer :sortable

      t.timestamps
    end
  end
end
