class Admin::BlogCategoriesController < AdminController
  
  include AdminCrudConcern

  before_action :find_blog_category, only: [:edit, :update, :destroy]

  def index
    @blog_categories = index_helper('blog_categories')
  end

  def edit
  end

  def new
    @blog_category = BlogCategory.new
  end

  def update
    update_helper(@blog_category, "edit_admin_blog_category_path", blog_category_params)
  end

  def create
    @blog_category = BlogCategory.new(blog_category_params)
    create_helper(@blog_category, "edit_admin_blog_category_path")
  end

  def destroy
    destroy_helper(@blog_category, "admin_blog_categorys_path")
  end

  private

  def find_blog_category
    @blog_category = BlogCategory.find(params[:id])
  end

  def blog_category_params
    params.require(:blog_category).permit(BlogCategory.attribute_names.map(&:to_sym))
  end
end