class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user
  has_one_attached :image
  validates :description, presence: true
  validate :image_presence  # custom validator
  validate :image_size

  def image_presence
    errors.add(:image, "must be attached") unless image.attached?
  end

  def image_size
    if image.attached? && image.blob.byte_size > 5.megabytes
      image.purge # remove the upload immediately
      errors.add(:image, "Uploaded image is too large (max 5MB)")
    end
  end

  def formatted_timestamp_primary
    time = time_ago_in_words(created_at) + " ago"
    created_at == updated_at ? time : time + " (Edited)"
  end

  def formatted_timestamp_hover
    "Last modified: " + time_ago_in_words(updated_at) + " ago"
  end
end
