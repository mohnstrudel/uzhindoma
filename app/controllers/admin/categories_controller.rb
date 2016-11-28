class Admin::CategoriesController < AdminController

	before_action :find_category, only: [:edit, :update]
	def index
		@categories = Category.all
	end

	def show
	end

	def edit
	end

	def new
		@category = Category.new
	end

	def create
		@category = Category.new(category_params)
		if @category.save
  			redirect_to admin_categories_path
      		flash[:success] = "Успешно создано"
  		else
  			render 'new'
  		end
	end

	def update
		if @category.update(category_params)
  			redirect_to edit_admin_category_path(@category)
			flash[:success] = "Успешно обновлено"
  		else
  			render 'edit'
  		end
	end

	private

	def find_category
		@category = Category.find(params[:id])
	end

	def category_params
		params.require(:category).permit(:name, :purchasable, :display_vital, :sortable)
	end
end
