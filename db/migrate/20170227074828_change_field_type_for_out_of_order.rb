class ChangeFieldTypeForOutOfOrder < ActiveRecord::Migration[5.0]
  def change
  	change_column :settings, :out_of_order_begin,  :text
  	change_column :settings, :out_of_order_end,  :text
  	
  end
end
