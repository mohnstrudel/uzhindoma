class AddCommentToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :comment, :text
  end
end
