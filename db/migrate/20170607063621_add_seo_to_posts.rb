class AddSeoToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :seo_description, :text
    add_column :posts, :seo_keywords, :string
  end
end
