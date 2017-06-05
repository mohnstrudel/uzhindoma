class Front::PostsController < FrontController

  def index
    if params[:blog_category_id].present?
      @posts = BlogCategory.find(params[:blog_category_id]).posts.order(created_at: :desc).paginate(:page => params[:page], :per_page => 20)
    elsif
      params[:keywords].present?
        @keywords = params[:keywords]
        post_search_term = PostSearchTerm.new(@keywords)
        @posts = Post.where(
          post_search_term.where_clause,
          post_search_term.where_args).
        order(post_search_term.order).
        paginate(:page => params[:page], :per_page => 20)
      @result_text = "Результат поиска по запросу: #{params[:keywords]}"
    else
      @posts = Post.all.order(created_at: :desc).paginate(:page => params[:page], :per_page => 4)
    end
    @categories = BlogCategory.all
  end

  def show
    @post = Post.find(params[:id])
  end
end
