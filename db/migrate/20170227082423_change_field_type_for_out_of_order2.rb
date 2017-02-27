class ChangeFieldTypeForOutOfOrder2 < ActiveRecord::Migration[5.0]
  def change
  	change_column :settings, :out_of_order_begin,  :string
  	change_column :settings, :out_of_order_end,  :string
  end
end
