class Picture < ActiveRecord::Base
	
	belongs_to :recipe
	mount_uploader :image, PictureUploader

end
