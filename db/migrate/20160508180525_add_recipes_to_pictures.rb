class AddRecipesToPictures < ActiveRecord::Migration[4.2]
  def change
    add_reference :pictures, :recipe, index: true, foreign_key: true
  end
end
