class User < ApplicationRecord
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_nil: true

  has_many :posts
end
