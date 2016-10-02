class AddOrderMailToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :order_mail, :string
  end
end
