class Front::DinnerController < FrontController
	def index
		@categories = Category.all
		@current_menus = Menu.current.sort_by { |menu| menu.category.sortable }
		@dessert = Menu.dessert[0]

		unless @current_menus.empty?
			@menu = @current_menus.first
			@order = Order.new(menu_id: @menu.id)
			@dessert_price = nil
			unless Menu.dessert[0].nil?
				@dessert_price ||= Menu.dessert[0].price
			end
		end
		
	end

	def new
		@order = Order.new
		respond_to do |format|
			format.json { p "hello" }
			format.html { p "test" }
		end
	end
end
