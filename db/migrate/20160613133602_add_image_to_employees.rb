class AddImageToEmployees < ActiveRecord::Migration[4.2]
  def change
    add_column :employees, :image, :string
  end
end
