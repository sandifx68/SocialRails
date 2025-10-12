FactoryBot.define do
  factory :message do
    association :from, factory: :user
    association :to, factory: :user
    text { "Test message" }
    seen { false }
  end
end
