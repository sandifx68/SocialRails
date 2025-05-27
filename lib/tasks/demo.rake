# lib/tasks/demo.rake

namespace :demo do
  desc "Delete all users and posts (including Active Storage attachments)"
  task clear: :environment do
    puts "Deleting all posts and users..."
    Post.find_each(&:destroy)
    User.find_each(&:destroy)
    puts "Done."
  end

  desc "Generate 5 demo users and posts with random content and attachments"
  task generate: :environment do
    require "faker"

    puts "Creating demo users and posts..."

    SEED_IMAGE_PATH = Rails.root.join("app", "assets", "images", "demo_images")
    IMAGES = Dir[SEED_IMAGE_PATH.join("*.jpg")].reject do |path|
      File.basename(path) == "pfp_too_big.jpg"
    end
    USER_AMOUNT = 5
    MAX_POSTS = 5
    MAX_PHOTOS_PER_POST = 3

    def random_image
      file = IMAGES.sample
      file ? File.open(file) : nil
    end

    USER_AMOUNT.times do
      words = Faker::Lorem.words(number: 2)
      display_name = words.join(" ").titleize
      user_id = words.join.downcase + rand(10..99).to_s

      user = User.new(
        display_name: display_name,
        user_id: user_id,
        description: Faker::Lorem.sentence(word_count: rand(0..20)),
        password: "password"
      )

      # Randomly attach profile and background photos
      user.profile_photo.attach(random_image) if rand < 0.8
      user.background_image.attach(random_image) if rand < 0.8

      user.save!
      puts "Created user: #{user.display_name}"

      rand(0..MAX_POSTS).times do
        post = user.posts.build(
          description: Faker::Lorem.words(number: rand(1..5)).join(" "),
          private: false
        )

        rand(1..MAX_PHOTOS_PER_POST).times do
          post.images.attach(random_image)
        end
        post.save!
        puts "Created public post with desc #{post.description}, having #{post.images.length} images."
      end
    end

    puts "Finished generating demo data."
  end
end
