class CreateMenudeliveries < ActiveRecord::Migration[5.1]
  def change
    create_table :menudeliveries do |t|
      t.belongs_to :menu, foreign_key: true
      t.belongs_to :delivery, foreign_key: true

      t.timestamps
    end
  end
end
