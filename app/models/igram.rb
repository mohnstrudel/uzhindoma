class Igram < ApplicationRecord
	mount_uploader :src_image, PictureUploader
	mount_uploader :userpic, PictureUploader
end
