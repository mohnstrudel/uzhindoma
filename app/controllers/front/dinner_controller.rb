class Front::DinnerController < FrontController
	def index
		@categories = Category.all
		@current_menus = Menu.current
		@menu = @current_menus.first
		@order = Order.new(menu_id: @menu.id)
		@dessert_price = nil
		@dessert_price ||= @current_menus[2].price
		
	end

	def new
		print "\n"
		print params
		print "\n"
	end
end
