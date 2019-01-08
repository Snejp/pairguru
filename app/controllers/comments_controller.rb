class CommentsController < ApplicationController
  def create
    # Find out what movie we are commenting
    prev_action = Rails.application.routes.recognize_path(request.referrer)
    unless prev_action[:controller] == "movies" and prev_action[:id] !~ /\D/
      render :json => {:error => "Something went wrong"} and return
    end

    # Check if user added a comment before
    movie_id = Integer(prev_action[:id])
    user_comments = Comment.where("user_id = ? AND movie_id = ?", current_user.id, movie_id)
    if user_comments.any?
      redirect_back fallback_location: movies_path and return
    end

    @comment = Comment.new(params.require(:comment).permit(:content))
    @comment.user = current_user
    @comment.movie_id = movie_id
    if @comment.save
      Rails.cache.delete("top_comments_key")
      redirect_back fallback_location: movies_path
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if current_user == @comment.user
      @comment.destroy
      Rails.cache.delete("top_comments_key")
    end

    redirect_back fallback_location: movies_path
  end
end
