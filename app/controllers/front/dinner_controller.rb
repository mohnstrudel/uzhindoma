class Front::DinnerController < FrontController
	def index
		@categories = Category.all
		@current_menus = Menu.current
	end
end
