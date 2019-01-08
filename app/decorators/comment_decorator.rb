class CommentDecorator < Draper::Decorator
  delegate_all

  def belogs_to(current_user)
    current_user == object.user
  end

  def user_avatar
    "http://lorempixel.com/40/40/people/#{object.user_id}/"
  end
end
