class Recipe < ActiveRecord::Base
	has_many :pictures, dependent: :destroy
	accepts_nested_attributes_for :pictures, allow_destroy: true

	has_many :menurecipes, dependent: :destroy
	has_many :menus, through: :menurecipes

	accepts_nested_attributes_for :menurecipes, allow_destroy: true

	validates :name, presence: true

end
