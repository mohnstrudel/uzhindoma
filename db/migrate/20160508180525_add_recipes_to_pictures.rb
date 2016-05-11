class AddRecipesToPictures < ActiveRecord::Migration
  def change
    add_reference :pictures, :recipe, index: true, foreign_key: true
  end
end
