class FrontController < ApplicationController
	layout 'front'

	def fast_order
		@order = Order.new
	end
end
