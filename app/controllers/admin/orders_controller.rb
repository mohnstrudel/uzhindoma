class Admin::OrdersController < AdminController

	def new
		@order = Order.new
	end

	def index
		@orders = Order.all
	end

	def edit
	end

	def create
		@order = Order.new(order_params)
	end

	def update
	end

	private

	def order_params
		params.require(:order).permit(:name, :address, :email, :pay_type, :phone, :category_id, :menu_id)
	end

	def find_order
		@order = Order.find(params[:id])
	end
end
