class CategoriesController < ApplicationController
  before_action :set_category, only: :show

  def show
    @posts = @category.posts.approved.all
    render 'posts/index'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

end