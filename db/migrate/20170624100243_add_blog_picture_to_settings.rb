class AddBlogPictureToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :blog_header_pic, :string
  end
end
