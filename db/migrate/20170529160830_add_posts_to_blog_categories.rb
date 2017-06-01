class AddPostsToBlogCategories < ActiveRecord::Migration[5.0]
  def change
    add_reference :blog_categories, :post, foreign_key: true
  end
end
