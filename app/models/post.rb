class Post < ApplicationRecord
  include Bootsy::Container

  mount_uploader :logo, BlogUploader
  
  belongs_to :blog_category

  validates :title, :blog_category, :body, :logo, presence: true
end
