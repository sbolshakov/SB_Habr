class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def show
    @posts = @category.posts
    render 'posts/index'
  end

  def edit
  end


  def create
    @category = Category.new(category_params)
      if @category.save
        redirect_to @category, notice: 'Создана новая категория'
      else
        render :new
      end
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: 'Категория изменена'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Категория удалена'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

end