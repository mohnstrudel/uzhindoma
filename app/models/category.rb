class Category < ActiveRecord::Base
	has_many :orders
	has_many :menus
end
