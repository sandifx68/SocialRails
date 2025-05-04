FactoryBot.define do
  factory :post do
    description { "This is a test post" }
    association :user # Automatically creates a user if not given
  end
end
