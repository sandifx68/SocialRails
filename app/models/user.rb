class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :profile_photo
  has_one_attached :background_image
  has_secure_password

  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :user_id, presence: true, uniqueness: true
  validate :profile_photo_size

  def recent_posts(limit = 10)
    posts.order(created_at: :desc).limit(limit) # Fetches latest posts
  end

  def profile_photo_size
    if profile_photo.attached? && profile_photo.blob.byte_size > 5.megabytes
      profile_photo.purge # remove the upload immediately
      errors.add(:profile_photo, "Uploaded image is too large (max 5MB)")
    end
  end
end
