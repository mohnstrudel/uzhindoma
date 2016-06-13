class Employee < ActiveRecord::Base
  belongs_to :jobtitle


  mount_uploader :image, PictureUploader

  scope :profession, -> (slug) { joins(:jobtitle).where('jobtitle.slug' == slug) }


  def grab_cobbles(index)
  	if index.even?
  		return self.image.url(:cobbles_horizontal)
  	else
  		return self.image.url(:cobbles_vertical)
  	end
  end
end
