class Admin::OrdersController < AdminController

	before_action :find_order, only: [:edit, :update]
	

	def new
		@order = Order.new
	end

	def index
		@orders = Order.order(created_at: :desc)
	end

	def edit
	end

	def create
		@order = Order.new(order_params)
		user_id = params[:order][:user_id]
		if user_id.empty?
			new_user = User.create(name: params[:order][:name], email: params[:order][:email], phone: params[:order][:phone], password: User.create_password)
			if new_user.save
				puts ""
				puts "new order user saved"
				puts ""
			else
				puts "user creation failed"
				new_user.errors.full_messages.each do |message|
					puts message
				end
			end
			puts ""
			puts "new user id is: #{new_user.id}"
			puts ""
			@order.user_id = new_user.id
		else
			@order.user = User.find(user_id)
		end

		puts ""
		puts "printing CREATE params:"
		puts params
		puts ""

		if @order.save
			redirect_to admin_orders_path
			flash[:success] = "Успешно создано"
		else
			@order.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'new'
  		end
	end

	def update
		puts ""
		puts "printing params:"
		puts params
		puts ""
		user_id = params[:order][:user_id]
		if user_id.empty?
			@order.user = User.find(user_id)
		else
			new_user = User.create(name: params[:name], email: params[:email], phone: params[:phone], password: User.create_password)
			@order.user = new_user.id
		end

		@order.menu_amount = params[:menu_amount]

		if @order.update(order_params)
			redirect_to edit_admin_order_path(@order)
			flash[:success] = "Успешно обновлено"
		else
			@order.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'edit'
  		end
	end

	private


	def order_params
		params.require(:order).permit(:name, :address, :email, :pay_type, :payed_online,
			:phone, :category_id, :menu_id, :menu_amount, :person_amount, :change, :user_id, :add_dessert)
	end

	def find_order
		@order = Order.find(params[:id])
	end
end
