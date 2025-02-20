class User < ApplicationRecord
  has_many :posts
  has_secure_password

  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :user_id, presence: true, uniqueness: true

  def recent_posts(limit = 10)
    posts.order(created_at: :desc).limit(limit) # Fetches latest posts
  end
end
