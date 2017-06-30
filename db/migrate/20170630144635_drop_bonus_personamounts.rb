class DropBonusPersonamounts < ActiveRecord::Migration[5.1]
  def change
    drop_table :bonus_personamounts, force: :cascade
  end
end
