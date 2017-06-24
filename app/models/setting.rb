class Setting < ActiveRecord::Base
  mount_uploader :blog_header_pic, BlogUploader
end
