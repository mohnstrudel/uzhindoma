class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :price, null: false
      t.string :alfa_order_id
      t.string :alfa_form_url
      t.boolean :paid
      t.string :description
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :payments, :alfa_order_id
    add_index :payments, :user_id
  end
end
