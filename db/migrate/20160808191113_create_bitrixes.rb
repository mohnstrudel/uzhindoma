class CreateBitrixes < ActiveRecord::Migration[4.2]
  def change
    create_table :bitrixes do |t|
      t.string :access_token
      t.string :refresh_token

      t.timestamps null: false
    end
  end
end
