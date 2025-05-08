FactoryBot.define do
  factory :user do
    sequence(:display_name) { |n| "User#{n}" }
    sequence(:user_id) { |n| "user#{n}" }
    sequence(:description) { |n| "description of user#{n}" }
    password { "complicatedPassword123GoogleBreach" }
  end
end
