class Admin::UsersController < AdminController

	before_action :find_user, only: [:edit, :update]
	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		@user.password = ('a'..'z').to_a.shuffle[0,8].join
		if @user.save
  			redirect_to admin_users_path
      		flash[:success] = "Успешно создано"
  		else
  			@user.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'new'
  		end
	end

	def edit

	end

	def update
		if @user.update(user_params)
			redirect_to edit_admin_user_path(@user)
			flash[:success] = "Успешно обновлено"
		else
			@user.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
			render 'edit'
		end
	end

	private

	def find_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation, :name, :phone, :address, :avatar)
	end
end