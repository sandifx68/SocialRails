class User < ApplicationRecord
  has_many :posts
  has_secure_password

  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :user_id, presence: true, uniqueness: true
end
