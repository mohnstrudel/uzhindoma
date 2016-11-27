class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :card_first_six
      t.string :card_last_four
      t.string :card_type
      t.string :issuer_bank_country
      t.string :token
      t.string :card_exp_date
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
