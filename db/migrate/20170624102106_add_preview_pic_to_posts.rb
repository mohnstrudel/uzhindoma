class AddPreviewPicToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :preview_pic, :string
  end
end
