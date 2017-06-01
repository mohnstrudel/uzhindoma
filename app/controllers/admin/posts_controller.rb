class Admin::PostsController < AdminController

  include AdminCrudConcern

  before_action :find_post, only: [:edit, :update, :destroy]

  def index
    @posts = index_helper('posts')
  end

  def edit
  end

  def new
    @post = Post.new
  end

  def update
    update_helper(@post, "edit_admin_post_path", post_params)
  end

  def create
    @post = Post.new(post_params)
    create_helper(@post, "edit_admin_post_path")
  end

  def destroy
    destroy_helper(@post, "admin_posts_path")
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(Post.attribute_names.map(&:to_sym).push(:bootsy_image_gallery_id))
  end
end
