class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: "Comment added."
    else
      @post.comments.reload
      render "posts/show", status: :unprocessable_entity
    end
  end

  def destroy
    binding.irb
    @comment = Comment.find(params[:id])
    if current_user?(@comment.user)
      @comment.destroy
      redirect_to request.referer || root_path, notice: "Comment successfully deleted!"
    else
      redirect_to root_path, alert: "You are not authorized to delete this comment."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
