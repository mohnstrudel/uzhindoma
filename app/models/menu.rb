class Menu < ActiveRecord::Base

  mount_uploader :hotpic, PictureUploader
  
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  belongs_to :category

  has_many :menurecipes
  has_many :recipes, through: :menurecipes

  accepts_nested_attributes_for :menurecipes

  def date
  	daterange.split(" - ")
  end
end
