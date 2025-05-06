class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user
  has_many_attached :images
  validates :description, presence: { message: "The description cannot be blank." }
  validate :image_presence  # custom validator
  validate :image_sizes

  def image_presence
    errors.add(:images, "An image must be attached.") unless images.attached?
    if images.attached? && images.length > 5
      errors.add(:images, "A post can't have more than 5 images.")
    end
  end

  def image_sizes
    images.each do |image|
      if image.blob.byte_size > 5.megabytes
        image.purge # removes the offending upload
        errors.add(:images, "Image '#{image.filename}' is too large (max 5MB)")
      end
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
