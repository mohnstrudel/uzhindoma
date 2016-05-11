class Menu < ActiveRecord::Base
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  belongs_to :category

  has_many :menurecipes
  has_many :recipes, through: :menurecipes

  accepts_nested_attributes_for :menurecipes
end
