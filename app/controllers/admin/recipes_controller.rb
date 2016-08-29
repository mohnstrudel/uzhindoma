class Admin::RecipesController < AdminController
  before_action :find_recipe, only: [:edit, :update, :destroy]

  def index
  	@recipes = Recipe.all
  end

  def show

  end

  def destroy
    if @recipe.destroy
      
      redirect_to admin_recipes_path
      flash[:alert] = 'Удалено успешно'
    else
      render 'index'
    end
  end

  def edit

  end

  def update
  	if @recipe.update(recipe_params)
      # debug
      if params[:pictures]
        params[:pictures].each { |image| @recipe.pictures.create(image: image) }
      end
  		redirect_to edit_admin_recipe_path(@recipe)
		  flash[:success] = "Успешно обновлено"
  	else
  		render 'edit'
  	end

  end

  def new
  	@recipe = Recipe.new
  end

  def create 
  	@recipe = Recipe.new(recipe_params)
    if params[:pictures]
  	  if @recipe.save
        params[:pictures].each { |image| @recipe.pictures.create(image: image) }
  		  redirect_to admin_recipes_path
        flash[:success] = "Успешно создано"
  	  else
  		  render 'new'
      end
    else
      @recipe.errors.add(:base, "Необходимо загрузить фотографию блюда!")
      render 'new'
  	end
  end

  private

  def find_recipe
  	@recipe = Recipe.find(params[:id])
  end

  def recipe_params
  	params.require(:recipe).permit(:id, :name, :description, :calories, :fat, :carbohydrates, :fileupload,
      pictures_attributes: [ :id, :image, :recipe_id, :_destroy ]
      )
  end
end
