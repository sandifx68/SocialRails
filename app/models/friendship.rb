class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validate :not_self
  validate :friendship_uniqueness, on: :create

  private

  def not_self
    errors.add(:friend, "can't be the same as user") if user_id == friend_id
  end

  def friendship_uniqueness
    if Friendship.where(user_id: user_id, friend_id: friend_id).or(Friendship.where(user_id: friend_id, friend_id: user_id)).exists?
      errors.add(:base, "Friendship already exists")
    end
  end
end
