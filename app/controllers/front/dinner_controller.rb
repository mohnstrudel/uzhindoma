class Front::DinnerController < FrontController
	def index
		@categories = Category.all
		@current_menus = Menu.no_dessert.current.sort_by { |menu| menu.category.sortable }
		@dessert = Menu.current_dessert[0]

		if @dessert.nil?
			@col_value = 6
		else
			@col_value = 4
		end

		unless @current_menus.empty?
			@menu = @current_menus.first
			@order = Order.new(menu_id: @menu.id)
			@dessert_price = 0
			unless @dessert.nil?
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
