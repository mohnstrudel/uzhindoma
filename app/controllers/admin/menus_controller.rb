class Admin::MenusController < AdminController

	before_action :find_menu, only: [:edit, :update]

	def index
		@menus = Menu.all
	end

	def new
		@menu = Menu.new
	end

	def edit
	end

	def update
		if @menu.update(menu_params)
			redirect_to edit_admin_menu_path(@menu)
			flash[:success] = "Успешно обновлено"
		else
			render "edit"
		end
	end

	def create
		@menu = Menu.new(menu_params)
		if @menu.save
  			redirect_to admin_menus_path
      		flash[:success] = "Успешно создано"
  		else
  			render 'new'
  		end
	end

	private

	def menu_params
		params.require(:menu).permit(:category_id, :price, :daterange, :hotpic, :remove_hotpic,
			{ recipe_ids: [] }, :change_from, :change_to, :description)
	end

	def find_menu
		@menu = Menu.find(params[:id])
	end
end
