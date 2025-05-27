class PostsController < ApplicationController
  before_action :require_login, only: [ :create, :new ]

  def require_login
    unless session[:user_id]
      redirect_to root_path, alert: "You must be logged in to do that."
    end
  end

  def index
    if current_user
      @posts = Post
        .joins(:user)
        .where("posts.private = ? OR users.id = (?) OR users.id IN (?)", false, current_user.id, current_user.friends.pluck(:id))
        .order(created_at: :desc)
        .page(params[:page])
        .per(5)
    else
      @posts = Post.where(private: false).order(created_at: :desc).page(params[:page]).per(5)
    end
  end


  def show
    post = Post.find(params[:id])
    unless post[:private] && !post.user.is_friends_with(current_user)
      @post = post
      @comment = Comment.new
    else
      redirect_to request.referer || root_path, alert: "You are not allowed to view this post."
    end
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

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    unless current_user?(@post.user)
      redirect_to root_path, alert: "You are not authorized to modify this post."
      return
    end

    if @post.update(post_params)
      redirect_to root_path, notice: "Post successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy_confirmation
    @post = Post.find(params[:id])
    render partial: "shared/modal", locals: {
      modal_title: "Are you sure you want to delete this post?",
      modal_body: render_to_string(partial: "shared/confirmation_modal_body", locals: { action: post_path(@post) })
    }
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user_id == session[:user_id]
      @post.destroy
      redirect_to request.referer || root_path, notice: "Post successfully deleted!"
    else
      redirect_to root_path, alert: "You are not authorized to delete this post."
    end
  end

  private

  def post_params
    params.require(:post).permit(:description, images: [])
  end
end
