class Order < ActiveRecord::Base
	belongs_to :category
	belongs_to :user
	belongs_to :menu

	has_one		:promocode
end
