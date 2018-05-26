class CreateLineItems < ActiveRecord::Migration[4.2]
  def change
    create_table :line_items do |t|
      t.references :menu, index: true, foreign_key: true
      t.belongs_to :cart, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
