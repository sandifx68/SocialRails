class FriendshipsController < ApplicationController
  def turbo_respond(user_to_render, is_friend)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("searched-user-#{user_to_render.user_id}",
        partial: "users/user_banner", locals: { user: user_to_render, friend: is_friend })
      }
      format.html { redirect_to root_path }
    end
  end

  def create
    @user = User.find(params[:user_id])
    @friend = User.find(params[:friend_id])
    Friendship.create!(user: @user, friend: @friend, accepted: false)

    turbo_respond @friend, false
  end

  # To accept friendship - only the person invited can accept the friendship
  def update
    @user = User.find(params[:user_id])
    @friend = User.find(params[:id])
    friendship = Friendship.find_by(user: @friend, friend: @user)

    if friendship
      friendship.update(accepted: true)
      turbo_respond @friend, true
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @friend = User.find(params[:id])
    friendship = Friendship.find_by(user: @user, friend: @friend) ||
                 Friendship.find_by(user: @friend, friend: @user)

    friendship&.destroy
    turbo_respond @friend, false
  end

  private
end
