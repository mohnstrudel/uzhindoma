class Admin::UsersController < AdminController

	before_action :find_user, only: [:edit, :update, :show]
	def index
		if params[:keywords].present?
        @keywords = params[:keywords]
        order_search_term = OrderSearchTerm.new(@keywords)
        @users = User.where(
          order_search_term.where_clause,
          order_search_term.where_args).
        order(order_search_term.order).
        paginate(:page => params[:page], :per_page => 30)
    else
      @users = User.order(id: :desc).paginate(:page => params[:page], :per_page => 30)
    end
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

  def password_recovery
    @user = User.find(params[:id])
    password = User.generate_password_code
    if @user.update(password: password)
      redirect_to edit_admin_user_path(@user)
      flash[:success] = "Пользователь обновлен с паролем - #{password}"
    else
      render :edit
      flash[:danger] = "Обновить пароль не получилось"
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