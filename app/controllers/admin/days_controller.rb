class Admin::DaysController < AdminController
before_action :find_day, only: [:edit, :update]
	

	def new
		@day = Day.new
	end

	def index
		@days = Day.order(created_at: :desc)
	end

	def edit
	end

	def create
		@day = Day.new(day_params)

		if @day.save
			redirect_to admin_days_path
			flash[:success] = "Успешно создано"
		else
			@day.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'new'
  		end
	end

	def update

		if @day.update(day_params)
			redirect_to edit_admin_day_path(@day)
			flash[:success] = "Успешно обновлено"
		else
			@day.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'edit'
  		end
	end

	private


	def day_params
		params.require(:day).permit(:value, :wordvalue, :pricechange)
	end

	def find_day
		@day = Day.find(params[:id])
	end
end
