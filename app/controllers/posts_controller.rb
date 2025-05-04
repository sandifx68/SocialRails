class PostsController < ApplicationController
  before_action :require_login, only: [ :create, :new ]

  def require_login
    unless session[:user_id]
      redirect_to root_path, alert: "You must be logged in to do that."
    end
  end

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = session[:user_id]  # assign the post to the logged-in user

    if @post.save
      redirect_to user_path(@post.user), notice: "Post created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:description, images: [])
  end
end
