class Admin::MenusController < AdminController

	before_action :find_menu, only: [:edit, :update, :destroy]

	def index
		@menus = Menu.all.order(end_time: :desc)
	end

	def new
		@menu = Menu.new
	end

	def edit

	end

	def destroy
    begin 
  		if @menu.destroy
    		redirect_to admin_menus_path, method: :get
    		flash[:success] = 'Удалено успешно'
      else
    		render 'index'
    		flash[:danger] = 'Что-то пошло не так'
      end
    rescue ActiveRecord::InvalidForeignKey => e
      redirect_to admin_menus_path
      flash[:danger] = "Удалить не получилось, так как уже существует заказ, в котором данное меню. Полный текст ошибки: #{e.message}"
    end
	end

	def update
		if @menu.update(menu_params)
			redirect_to edit_admin_menu_path(@menu), method: :get
			flash[:success] = "Успешно обновлено"
		else
			render :edit
      flash[:danger] = "Что-то пошло не так"
		end
	end

	def create
		@menu = Menu.new(menu_params)
		if @menu.save
  			redirect_to admin_menus_path, method: :get
      	flash[:success] = "Успешно создано"
  		else
  			
        flash[:danger] = "Что-то пошло не так"
        render :new
  		end
	end

	private

	def menu_params
		params.require(:menu).permit(:category_id, :price, :daterange, :hotpic, :remove_hotpic,
			{ delivery_ids: [] }, { recipe_ids: [] }, { personamount_ids: [] }, { b_personamount_ids: [] }, { day_ids: [] }, :change_from, 
			:change_to, :description, :has_dessert, :has_breakfast,
      menurecipes_attributes: [:id, :sortable, :menu_id, :recipe_id, :_destroy, recipe_attributes: [:id, :_destroy]]
      
      )
	end

	def find_menu
		@menu = Menu.find(params[:id])
	end
end
