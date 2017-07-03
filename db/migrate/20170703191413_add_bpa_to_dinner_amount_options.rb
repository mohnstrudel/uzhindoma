class AddBpaToDinnerAmountOptions < ActiveRecord::Migration[5.1]
  def change
    add_reference :dinner_amount_options, :b_personamount, foreign_key: true
  end
end
