class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user
  validates :description, presence: true


  def formatted_timestamp_primary
    time = time_ago_in_words(created_at) + " ago"
    created_at == updated_at ? time : time + " (Edited)"
  end

  def formatted_timestamp_hover
    "Last modified: " + time_ago_in_words(updated_at) + " ago"
  end
end
