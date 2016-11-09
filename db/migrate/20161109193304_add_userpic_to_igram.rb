class AddUserpicToIgram < ActiveRecord::Migration[5.0]
  def change
    add_column :igrams, :userpic, :string
  end
end
