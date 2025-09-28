FactoryBot.define do
  factory :friendship do
    association :user
    association :friend, factory: :user
    accepted { true }
  end
end
