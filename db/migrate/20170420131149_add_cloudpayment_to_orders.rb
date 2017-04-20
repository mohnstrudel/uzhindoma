class AddCloudpaymentToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :cloudpayment, :boolean
  end
end
