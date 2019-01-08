class TopCommentsController < ApplicationController
  def index
    @top_comments = Rails.cache.read("top_comments_key")
    if @top_comments.nil?
      @top_comments = get_top_comments
      Rails.cache.write("top_comments_key", @top_comments)
    end
  end

  private
  def get_top_comments
    User.joins(:comments)
      .select("users.*" ,"count(comments.id) AS count_comments")
      .where("comments.created_at >= ?", 1.week.ago)
      .order("count_comments desc")
      .group("users.id")
      .limit(10).to_a
  end
end
