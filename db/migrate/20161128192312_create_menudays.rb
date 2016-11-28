class CreateMenudays < ActiveRecord::Migration[5.0]
  def change
    create_table :menudays do |t|
      t.belongs_to :day, foreign_key: true
      t.belongs_to :menu, foreign_key: true

      t.timestamps
    end
  end
end
