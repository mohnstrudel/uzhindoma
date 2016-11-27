class AddWordvalueToPersonamounts < ActiveRecord::Migration[5.0]
  def change
    add_column :personamounts, :wordvalue, :string
  end
end
