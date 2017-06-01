class Front::BlogCategoriesController < FrontController
  def show
    @posts = BlogCategory.includes(:posts).find(params[:id]).posts
  end
end
