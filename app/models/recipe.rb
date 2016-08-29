class Recipe < ActiveRecord::Base
	has_many :pictures, dependent: :destroy
	accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

	has_many :menurecipes
	has_many :menus, through: :menurecipes

	accepts_nested_attributes_for :menurecipes

	validates :name, presence: true

end
