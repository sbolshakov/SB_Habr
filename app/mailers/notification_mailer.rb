class NotificationMailer < ApplicationMailer

  def comment_notification(subscriber, post, comment)
    @subscriber = subscriber
    @post = post
    @comment = comment
    mail(to: subscriber.email, subject: 'Новый комментарий')
  end

  def post_approved_notification(post)
    @post = post
    mail(to: post.user.email, subject: 'Ваша публикация прошла модерирование!')
  end

  def post_rejected_notification(post)
    @post = post
    mail(to: post.user.email, subject: 'Ваша публикация прошла отклонена!')
  end

end
