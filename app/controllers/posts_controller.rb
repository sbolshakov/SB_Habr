class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish, :unpublish, :approve,
                                  :reject, :subscribe, :unsubscribe]
  before_action :check_owner, only: [:edit, :update, :destroy, :publish, :unpublish, :approve, :reject]

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
    unless current_user.admin?
      @posts = Post.pending.where(user_id: current_user.id)
    else
      @posts = Post.pending.all
    end
  end

  def publish
    @post.pending!
    redirect_to posts_url, notice: 'Отправлено на модерирование.'
  end

  def unpublish
    @post.draft!
    redirect_to drafts_posts_url, notice: 'Перемещен в черновики.'
  end

  def reject
    @post.draft!
    NotificationMailer.post_rejected_notification(@post).deliver_now
    redirect_to pending_posts_url, notice: 'Публикация отклонена.'
  end

  def approve
    @post.approved!
    NotificationMailer.post_approved_notification(@post).deliver_now
    redirect_to pending_posts_url, notice: 'Публикация одобрена.'
  end

  def subscribe
    @post.subscribers << current_user unless @post.subscribers.include?(current_user)
    redirect_to @post, notice: 'Вы успешно подписались на комментарии.'
  end

  def unsubscribe
    @post.subscribers.delete(current_user) unless !@post.subscribers.include?(current_user)
    redirect_to @post, notice: 'Вы успешно отписались от комментариев.'
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
      @post.subscribers << current_user # unless @post.subscribers.include?(current_user)
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      @post.draft!
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def check_owner
      unless current_user.owner_of?(@post)
        redirect_to posts_path, alert: 'У вас нет прав на выполнение этого действия!'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, category_ids: [])
    end
end
