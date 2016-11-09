class ChangeIgramDescriptionColumnType < ActiveRecord::Migration[5.0]
  def change
  	change_column :igrams, :description,  :text
  end
end
