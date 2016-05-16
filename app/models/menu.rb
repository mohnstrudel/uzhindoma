class Menu < ActiveRecord::Base

  mount_uploader :hotpic, PictureUploader
  
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  belongs_to :category

  has_many :menurecipes
  has_many :recipes, through: :menurecipes

  accepts_nested_attributes_for :menurecipes

  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  has_many :orders

  def date
    daterange.split(" - ")
  end

  private

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, "Line Items present")
      return false
    end
  end


end
