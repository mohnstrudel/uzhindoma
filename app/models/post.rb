class Post < ApplicationRecord
  include Bootsy::Container

  mount_uploader :logo, BlogUploader
  
  belongs_to :blog_category

  validates :title, :blog_category, :body, :logo, presence: true

  def similar
    Post.where(blog_category_id: self.blog_category_id)
  end

  def next
    Post.where("id > ?", self.id).first
  end

  def prev
    Post.where("id < ?", self.id).last
  end

end
