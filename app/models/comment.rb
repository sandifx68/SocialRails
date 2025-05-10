class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :text, presence: { message: "The comment text cannot be blank." }
end
