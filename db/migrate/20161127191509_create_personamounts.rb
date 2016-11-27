class CreatePersonamounts < ActiveRecord::Migration[5.0]
  def change
    create_table :personamounts do |t|
      t.integer :value

      t.timestamps
    end
  end
end
