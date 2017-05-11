class AddDiscountToPromocodes < ActiveRecord::Migration[5.0]
  def change
    add_column :promocodes, :discount, :integer
  end
end
