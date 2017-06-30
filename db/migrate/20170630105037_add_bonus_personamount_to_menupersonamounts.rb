class AddBonusPersonamountToMenupersonamounts < ActiveRecord::Migration[5.1]
  def change
    add_reference :menupersonamounts, :bonus_personamount, foreign_key: true
  end
end
