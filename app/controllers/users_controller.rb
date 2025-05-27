class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if @user&.authenticate(user_params[:password])
        session[:user_id] = @user.id
      end
      redirect_to root_path, notice: "Account created successfully!"
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def search
    page = params[:page] || 1

    if current_user.present?
      if params[:query].present?
        @friends = current_user.friends(params[:query])
        @friend_requests = current_user.friend_requests_received(params[:query])
        @users = User.where("user_id ILIKE ?", "%#{params[:query]}%") - @friends - @friend_requests
      else
        @friends = current_user.friends
        @friend_requests = current_user.friend_requests_received
        @users = User.all - [ current_user ]
      end
    else
      @friends = []
      @friend_requests = []
      @users = if params[:query].present?
        User.where("user_id ILIKE ?", "%#{params[:query]}%")
      else
        User.all
      end
    end

    @paginated_users = Kaminari.paginate_array(@users).page(page).per(5)
    @paginated_friends = Kaminari.paginate_array(@friends).page(page).per(5)

    respond_to do |format|
      format.turbo_stream {
        render partial: "users/search_results",
               locals: {
                 users: @paginated_users,
                 friends: @paginated_friends,
                 friend_requests: @friend_requests
               }
      }
      format.html {
        render partial: "users/search_results",
               locals: {
                 users: @paginated_users,
                 friends: @paginated_friends,
                 friend_requests: @friend_requests
               }
      }
    end
  end

  def edit_display_name
    @user = User.find(params[:id])
    render_partial("Edit Display Name", :display_name, update_display_name_user_path(@user), "text")
  end

  def update_display_name
    @user = User.find(params[:id])
    if current_user? && @user.update(display_name: params[:user][:display_name])
      redirect_to user_path(@user), notice: "Display Name updated!"
    else
      redirect_to user_path(@user), alert: "You are not authorized to do that."
    end
  end

  def edit_description
    @user = User.find(params[:id])
    render_partial("Edit Description", :description, update_description_user_path(@user), "text")
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
    render_partial("Edit Profile Photo", :profile_photo, update_photo_user_path(@user), "photo")
  end

  def update_photo
    @user = User.find(params[:id])
    validate_and_update_image(:profile_photo, "Profile photo updated!", "Edit Profile Photo", update_photo_user_path(@user))
  end


  def edit_background_image
    @user = User.find(params[:id])
    render_partial("Edit Background Image", :background_image, update_background_image_user_path(@user), "photo")
  end

  def update_background_image
    @user = User.find(params[:id])
    validate_and_update_image(:background_image, "Background image updated!", "Edit Background Image", update_background_image_user_path(@user))
  end

  private

  def render_partial(title, field, update_path, type)
    render partial: "shared/modal", locals: {
      modal_title: title,
      modal_body: render_to_string(partial: "users/forms/edit_#{type}", locals: {
        user: @user,
        field: field,
        update_path: update_path
      })
    }
  end

  # This is kinda bad - those validations should be done in the user model
  # and this would be reduced to a simple if else
  def validate_and_update_image(field, notice, modal_title, update_path)
    unless current_user?
      return redirect_to user_path(@user), alert: "You are not authorized to do that."
    end

    if params[:user].present? && params[:user][field].present?
      # use hash
      if @user.update(field => params[:user][field])
        redirect_to user_path(@user), notice: notice
      else
        render_partial(modal_title, field, update_path, "photo")
      end
    else # No file submitted
      @user.errors.add(field, "must be selected before uploading")
      render_partial(modal_title, field, update_path, "photo")
    end
  end

  def user_params
    params.require(:user).permit(:user_id, :display_name, :password, :password_confirmation)
  end
end
