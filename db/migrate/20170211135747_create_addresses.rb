class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :house_number
      t.string :flat_number
      t.string :delivery_region
      t.string :city
      t.string :additional_address
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
