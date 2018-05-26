class CreateSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :settings do |t|
      t.string :instagram
      t.string :facebook
      t.string :vkontakte
      t.string :phone

      t.timestamps null: false
    end
  end
end
