class Category < ActiveRecord::Base
	has_many :orders
end
