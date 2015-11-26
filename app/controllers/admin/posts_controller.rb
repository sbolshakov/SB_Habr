class Admin::PostsController < Admin::BaseController

  before_action :set_post, only: [:reject, :approve]

  def pending
      @posts = Post.pending.all
  end

  def reject
    @post.draft!
    NotificationMailer.post_rejected_notification(@post).deliver_now
    redirect_to pending_admin_posts_url, notice: t('admin.posts.rejected')
  end

  def approve
    @post.approved!
    NotificationMailer.post_approved_notification(@post).deliver_now
    redirect_to pending_admin_posts_url, notice: t('admin.posts.approved')
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end


end