class AddSeoToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :seo_title, :string
    add_column :settings, :seo_description, :text
    add_column :settings, :seo_keywords, :string
  end
end
