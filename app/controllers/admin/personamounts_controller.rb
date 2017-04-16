class Admin::PersonamountsController < AdminController
	before_action :find_personamount, only: [:edit, :update, :destroy]
	

	def new
		@personamount = Personamount.new
    @personamount.dinner_amount_options.build
	end

	def index
		@personamounts = Personamount.order(created_at: :desc)
	end

	def edit
    if @personamount.dinner_amount_options.blank?
      @personamount.dinner_amount_options.build
    end
	end

	def destroy
	    if @personamount.destroy
      		redirect_to admin_personamounts_path
      		flash[:alert] = 'Удалено успешно'
    	else
      		render 'index'
    	end
	end

	def create
		@personamount = Personamount.new(personamount_params)

		if @personamount.save
			redirect_to admin_personamounts_path
			flash[:success] = "Успешно создано"
		else
			@personamount.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'new'
  		end
	end

	def update

		if @personamount.update(personamount_params)
			redirect_to edit_admin_personamount_path(@personamount)
			flash[:success] = "Успешно обновлено"
		else
			@personamount.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'edit'
  		end
	end

	private


	def personamount_params
		params.require(:personamount).permit(:value, :wordvalue, :pricechange, :title, :pricechange_life, :sortable,
      dinner_amount_options_attributes: [:day_number, :pricechange, :personamount_id, :id, :_destroy])
	end

	def find_personamount
		@personamount = Personamount.find(params[:id])
	end
end
