class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :friends, through: :friendships
  has_one_attached :profile_photo
  has_one_attached :background_image
  has_secure_password

  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :display_name, presence: true
  validates :user_id, presence: true, uniqueness: true
  validate :profile_photo_size

  def friends(user_id_filter = "")
    sanitized_filter = "%#{user_id_filter.downcase}%"

    User.find_by_sql([ <<-SQL, id, sanitized_filter, id, sanitized_filter ])
    SELECT users.*
    FROM friendships
    JOIN users ON (
        (friendships.user_id = ? AND friendships.friend_id = users.id AND LOWER(users.user_id) LIKE ?) OR
        (friendships.friend_id = ? AND friendships.user_id = users.id AND LOWER(users.user_id) LIKE ?)
      )
      WHERE friendships.accepted = TRUE
    SQL
  end

  def friends_ordered_by_messages
    User.find_by_sql([
      <<-SQL, id, id, id, id, id
        WITH
          friends AS ( -- Friends of the user
            SELECT users.* FROM friendships f
            JOIN users ON (
              (f.user_id = ? AND f.friend_id = users.id) OR
              (f.friend_id = ? AND f.user_id = users.id) )
            WHERE f.accepted = TRUE
          ),
          conv AS ( -- Last message with each other user
            SELECT
              CASE WHEN m.from_id = ? THEN m.to_id ELSE m.from_id END AS other_user_id,
              MAX(m.created_at) AS last_message_at
              FROM messages m
              WHERE m.from_id = ? OR m.to_id = ?
              GROUP BY other_user_id
          )
        SELECT friends.*
          FROM friends LEFT JOIN conv ON conv.other_user_id = friends.id
          ORDER BY conv.last_message_at DESC NULLS LAST, friends.display_name ASC
      SQL
    ])
  end

  def is_friends_with(user)
    self.friends.include?(user)
  end

  def friend_requests_sent
    Friendship.where(accepted: false).where("user_id = ?", id).map do |f|
      f.friend
    end
  end

  def friend_requests_received(user_id_filter = "")
    Friendship.where(accepted: false).where("friend_id = ?", id).map do |f|
      if f.user.user_id.downcase.include? user_id_filter.downcase
        f.user
      end
    end
  end

  def recent_posts(limit = 10)
    posts.order(created_at: :desc).limit(limit) # Fetches latest posts
  end

  def last_message_between(friend)
    unless is_friends_with(friend)
      raise "Cannot see last message unless you are friends with that other user."
    end

    Message.where(from: friend, to: self)
      .or(Message.where(from: self, to: friend))
      .order(created_at: :desc)
      .first
  end

  def profile_photo_size
    if profile_photo.attached? && profile_photo.blob.byte_size > 5.megabytes
      profile_photo.purge # remove the upload immediately
      errors.add(:profile_photo, "Uploaded image is too large (max 5MB)")
    end
  end
end
