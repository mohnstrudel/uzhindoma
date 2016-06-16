class Front::OrdersController < FrontController

	before_action :find_order, only: [:show]

	def new
		@order = Order.new
		@menu = Menu.find(params[:menu_id])
		@menu_price = @menu.calculate_price(@menu, params)
	end

	def create
		@order = Order.new(order_params)

		if params[:menu_type]
			@order.menu_type = params[:menu_type]
		end

		if @order.save
			respond_to do |format|
				format.html { redirect_to @order}
			end

			unless params[:order][:order_type] == "fast"
				OrderNotifier.received(@order).deliver_now
			end
			OrderNotifier.notifyShop(@order).deliver_now
		else
			render "new"
		end
	end

	def show
	end

	private

	def order_params
		params.require(:order).permit(:name, :address, :city, :phone, :email, 
			:person_amount, :menu_amount, :add_dessert, :user_id, :change, :menu_id,
			:order_type, :menu_type)
	end

	def find_order
		@order = Order.find(params[:id])
	end


end
