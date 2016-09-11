class Category < ActiveRecord::Base
	has_many :orders
	has_many :menus

	scope :dessert, ->{where(name: 'Десерт')}
end
