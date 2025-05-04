class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(user_id: params[:user_id])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid display name or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

  def display_name
    display_name = User.find_by(user_id: session[:user_id]).display_name
    display_name || flash[:alert] = "Currently not logged in."
  end
end
