class CreateBonusPersonamounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bonus_personamounts do |t|

      t.timestamps
    end
  end
end
