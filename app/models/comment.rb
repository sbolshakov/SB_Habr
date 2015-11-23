class Comment < ActiveRecord::Base

  belongs_to :post
  belongs_to :user

  validates :body, :post_id, :user_id, presence: true

  after_save :send_notification

  private

  def send_notification
    post.subscribers.each do |subscriber|
      NotificationMailer.comment_notification(subscriber, post, self).deliver_now
    end
  end

end
