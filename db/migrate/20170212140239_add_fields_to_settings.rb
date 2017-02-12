class AddFieldsToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :out_of_order_begin, :integer
    add_column :settings, :out_of_order_end, :integer
  end
end
