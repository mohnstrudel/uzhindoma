class CreateIntervals < ActiveRecord::Migration[5.1]
  def change
    create_table :intervals do |t|
      t.string :value
      t.belongs_to :delivery, foreign_key: true

      t.timestamps
    end
  end
end
