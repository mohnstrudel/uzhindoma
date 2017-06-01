class Front::PostsController < FrontController

  def index
    if params[:blog_category_id].present?
      @posts = BlogCategory.find(params[:blog_category_id]).posts.order(created_at: :desc)
    else
      @posts = Post.all.order(created_at: :desc)
    end
    @categories = BlogCategory.all
  end

  def show
    @post = Post.find(params[:id])
  end
end
