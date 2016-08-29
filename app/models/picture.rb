class Picture < ActiveRecord::Base
	
	belongs_to :recipe
	mount_uploader :image, PictureUploader

	validates :image, presence: true

end
