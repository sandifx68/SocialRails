FactoryBot.define do
  factory :post do
    description { "This is a test post" }
    private { false }
    association :user # Automatically creates a user if not given
    after(:build) do |post|
      post.images.attach(
        io: File.open(Rails.root.join('app', 'assets', 'images', 'demo_images', 'alt_post_0.jpg')),
        filename: 'test_image.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
