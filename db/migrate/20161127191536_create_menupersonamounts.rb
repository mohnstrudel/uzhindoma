class CreateMenupersonamounts < ActiveRecord::Migration[5.0]
  def change
    create_table :menupersonamounts do |t|
      t.belongs_to :menu, foreign_key: true
      t.belongs_to :personamount, foreign_key: true

      t.timestamps
    end
  end
end
