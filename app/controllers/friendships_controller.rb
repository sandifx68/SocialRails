class FriendshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @friend = User.find(params[:friend_id])
    Friendship.create!(user: @user, friend: @friend, accepted: false)
    redirect_to root_path# , notice: "Friendship request sent!"
  end

  # To accept friendship - only the person invited can accept the friendship
  def update
    @user = User.find(params[:user_id])
    @friend = User.find(params[:id])
    friendship = Friendship.find_by(user: @friend, friend: @user)

    if friendship
      friendship.update(accepted: true)
    end

    redirect_to root_path# , notice: "Friendship accepted!"
  end

  def destroy
    @user = User.find(params[:user_id])
    @friend = User.find(params[:id])
    friendship = Friendship.find_by(user: @user, friend: @friend) ||
                 Friendship.find_by(user: @friend, friend: @user)

    friendship&.destroy
    redirect_to root_path# , notice: "Friend removed!"
  end

  private
end
