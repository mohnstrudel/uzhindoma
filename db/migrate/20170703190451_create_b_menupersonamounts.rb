class CreateBMenupersonamounts < ActiveRecord::Migration[5.1]
  def change
    create_table :b_menupersonamounts do |t|
      t.belongs_to :menu, foreign_key: true
      t.belongs_to :b_personamount, foreign_key: true

      t.timestamps
    end
  end
end
