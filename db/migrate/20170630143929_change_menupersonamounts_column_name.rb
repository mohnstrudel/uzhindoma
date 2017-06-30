class ChangeMenupersonamountsColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :menupersonamounts, :bonus_personamount_id, :bonuspersonamount_id
  end
end
