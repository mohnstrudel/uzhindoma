class Front::PostsController < FrontController

  def index
    

    post_amount = Post.all.count
    posts_value = Rails.application.config.posts_pages
    @page = (params[:page] || 1).to_i
    @pages_total = post_amount / posts_value
    if post_amount%posts_value != 0
      @pages_total += 1
    end

    if params[:blog_category_id].present?
      @posts = BlogCategory.find(params[:blog_category_id]).posts.order(created_at: :desc).paginate(:page => params[:page], :per_page => posts_value)
    elsif
      params[:keywords].present?
        @keywords = params[:keywords]
        post_search_term = PostSearchTerm.new(@keywords)
        @posts = Post.where(
          post_search_term.where_clause,
          post_search_term.where_args).
        order(post_search_term.order).
        paginate(:page => params[:page], :per_page => posts_value)
      @result_text = "Результат поиска по запросу: #{params[:keywords]}"
    else
      @posts = Post.all.order(created_at: :desc).paginate(:page => params[:page], :per_page => posts_value)
    end
    @categories = BlogCategory.all
  end

  def show
    @post = Post.find(params[:id])
    @url = CGI.escape(absolute_url)
  end

  private
    def absolute_url
      request.base_url + request.original_fullpath
    end
end
