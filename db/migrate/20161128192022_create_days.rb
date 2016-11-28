class CreateDays < ActiveRecord::Migration[5.0]
  def change
    create_table :days do |t|
      t.integer :value
      t.string :wordvalue

      t.timestamps
    end
  end
end
