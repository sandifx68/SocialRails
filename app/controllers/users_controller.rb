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

    render partial: "shared/modal", locals: {
      modal_title: "Edit Description",
      modal_body: render_to_string(partial: "users/forms/edit_description", locals: { user: @user })
    }
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

  def edit_photo
    @user = User.find(params[:id])

    render partial: "shared/modal", locals: {
      modal_title: "Edit Profile Picture",
      modal_body: render_to_string(partial: "users/forms/edit_photo", locals: {
        user: @user,
        field: :profile_photo,
        upload_path: update_photo_user_path(@user)
      })
    }
  end

  def update_photo
    @user = User.find(params[:id])
    # using method from application controller
    if current_user? && @user.update(profile_photo: params[:user][:profile_photo])
      redirect_to user_path(@user), notice: "Profile photo updated!"
    else
      redirect_to user_path(@user), alert: "You are not authorized to do that."
    end
  end

  def edit_background_image
    @user = User.find(params[:id])

    render partial: "shared/modal", locals: {
      modal_title: "Edit Background Image",
      modal_body: render_to_string(partial: "users/forms/edit_photo", locals: {
        user: @user,
        field: :background_image,
        upload_path: update_background_user_path(@user)
      })
    }
  end

  def update_background_image
    @user = User.find(params[:id])
    if @user.update(background_image: params[:user][:background_image])
      redirect_to user_path(@user), notice: "Background image updated."
    else
      redirect_to user_path(@user), alert: "Failed to update background."
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_id, :display_name, :password, :password_confirmation)
  end
end
