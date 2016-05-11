class Recipe < ActiveRecord::Base
	has_many :pictures, dependent: :destroy
	accepts_nested_attributes_for :pictures, allow_destroy: true

	has_many :menurecipes
	has_many :menus, through: :menurecipes

	accepts_nested_attributes_for :menurecipes
end
