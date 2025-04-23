class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "Account created successfully!"
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit_description
    @user = User.find(params[:id])
    render "users/edit_description"
  end

  def update_description
    @user = User.find(params[:id])
    # using method from application controller
    if current_user? && @user.update(description: params[:user][:description])
      redirect_to user_path(@user), notice: "Description updated!"
    else
      redirect_to user_path(@user), alert: "You are not authorized to do that."
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_id, :display_name, :password, :password_confirmation)
  end
end
