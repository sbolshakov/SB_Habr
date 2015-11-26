class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish, :unpublish]
  before_action :check_owner, only: [:edit, :update, :destroy, :publish, :unpublish]

  # GET /posts
  def index
    @posts = Post.approved.all
  end

  def drafts
    unless current_user.admin?
      @posts = Post.draft.where(user_id: current_user.id)
    else
      @posts = Post.draft.all
    end
  end

  def pending
      @posts = Post.pending.where(user_id: current_user.id)
  end

  def publish
    @post.pending!
    redirect_to posts_url, notice: t('posts.notices.submit_to_moderator')
  end

  def unpublish
    @post.draft!
    redirect_to drafts_posts_url, notice: t('posts.notices.moved_to_drafts')
  end

  # GET /posts/1
  def show
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post, notice: t('posts.notices.created')
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      @post.draft!
      redirect_to @post, notice: t('posts.notices.updated')
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: t('posts.notices.destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def check_owner
      unless current_user.owner_of?(@post)
        redirect_to posts_path, alert: t('common.not_enough_rights')
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, category_ids: [])
    end
end
