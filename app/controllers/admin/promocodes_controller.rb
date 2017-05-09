class Admin::PromocodesController < AdminController
	before_action :find_promocode, only: [:edit, :update, :destroy]
	

	def new
		@promocode = Promocode.new
	end

	def index
		@promocodes = Promocode.not_used_yet.order(created_at: :desc)
	end

	def edit
	end

	def create
		# @promocode = Promocode.new(promocode_params)

		amount = params[:amount].to_i
		promocodes = Array.new
		amount.times.each do |amount_unit|
			promocodes << Promocode.generate_code
		end

		if promocodes.map { |pcode| Promocode.new(value: pcode, discount: params[:discount]).save }
			redirect_to admin_promocodes_path
			flash[:success] = "Успешно создано"
		else
			@promocode.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'new'
  		end
	end

	def update

		if @promocode.update(promocode_params)
			redirect_to edit_admin_promocode_path(@promocode)
			flash[:success] = "Успешно обновлено"
		else
			@promocode.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'edit'
  		end
	end

	def destroy
	    if @promocode.destroy
      		redirect_to admin_promocodes_path
      		flash[:alert] = 'Удалено успешно'
    	else
      		render 'index'
    	end
	end

	private


	def promocode_params
		params.require(:promocode).permit(:value, :discount)
	end

	def find_promocode
		@promocode = Promocode.find(params[:id])
	end
end
