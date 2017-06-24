class AddBlogTextToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :blog_main_text, :string
  end
end
