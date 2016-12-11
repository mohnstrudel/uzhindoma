class FixPromocodeColumName < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :promocode, :pcode
  end
end
