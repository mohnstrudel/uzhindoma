class AddFullNamesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :second_name, :string
    add_column :users, :delivery_region, :string
    add_column :users, :street, :string
    add_column :users, :house_number, :string
    add_column :users, :korpus, :string
    add_column :users, :flat_number, :string
  end
end
