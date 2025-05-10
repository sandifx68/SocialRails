class LikesController < ApplicationController
  def turbo_respond
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("like-button-#{@post.id}", partial: "posts/like_button", locals: { post: @post }) }
      format.html { redirect_to @post }
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.create(user: current_user)

    turbo_respond
  end

  def destroy
    @like = Like.find(params[:id])
    @post = Post.find(params[:post_id])
    if current_user?(@like.user)
      @like.destroy
      turbo_respond
    else
      redirect_to root_path, alert: "You are not authorized to delete this like."
    end
  end
end
