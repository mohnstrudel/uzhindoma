class CreatePromocodes < ActiveRecord::Migration[5.0]
  def change
    create_table :promocodes do |t|
      t.string :value

      t.timestamps
    end
  end
end
