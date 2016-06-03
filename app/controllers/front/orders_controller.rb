class Front::OrdersController < FrontController
	def new
		@menu = Menu.find(params[:menu_id])
	end

	def create
	end
end
