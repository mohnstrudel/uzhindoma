class Admin::UsersController < AdminController

	before_action :find_user, only: [:edit, :update, :show]
	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def show
		puts @user
		respond_to do |format|
			format.json { render json: @user.to_json }
		end

	end

	def create
		@user = User.new(user_params)
		@user.password = User.create_password
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