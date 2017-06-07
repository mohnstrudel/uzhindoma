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

  def to_description
    if self.seo_description.present?
      return self.seo_description
    elsif self.respond_to?(:description)
      return self.description.truncate(150)
    else
      return self.body.truncate(150)
    end
  end

  def to_keywords
    if self.seo_keywords.present?
      keywords = self.seo_keywords.split(",")
      return keywords
    else
      keywords = self.title.split(" ")
      return keywords
    end
  end

end
