class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: t('admin.categories.notices.new_category')
      else
        render :new
      end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: t('admin.categories.notices.category_update')
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: t('admin.categories.notices.remove')
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

end