require 'rails_helper'

RSpec.feature "Posts create", type: :feature do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  def fixture_path(filename)
    Rails.root.join('spec', 'fixtures', 'files', filename)
  end

  scenario "allows user to post single photo", js: true do
    log_in_as(user)
    visit new_post_path

    fill_in "post_description", with: "Post title"
    attach_file "post_images", fixture_path('alt_post_0.jpg')
    expect(page).to have_selector "#preview-image-0"
    click_button "Create Post"

    expect(page).to have_text "Post title"
    image = page.find(".post-image")
    expect(image[:src]).to include("alt_post_0.jpg")
  end

  scenario "allows user to post multiple photos", js: true do
    log_in_as(user)
    visit new_post_path

    fill_in "post_description", with: "Post title"
    attach_file "post_images", [
      fixture_path('alt_post_0.jpg'),
      fixture_path('alt_post_1.jpg'),
      fixture_path('alt_post_2.jpg')
    ]
    (0..2).each do |i|
      expect(page).to have_selector "#preview-image-#{i}"
    end
    click_button "Create Post"

    expect(page).to have_text "Post title"
    images = page.all(".post-image", visible: :all)
    (0..2).each do |i|
      expect(images[i][:src]).to include("alt_post_#{i}.jpg")
    end
  end

  scenario "doesn't allow user to post more than 5 photos" do
    log_in_as(user)
    visit new_post_path

    fill_in "post_description", with: "Post title"
    attach_file "post_images", [
      fixture_path('alt_post_0.jpg'),
      fixture_path('alt_post_1.jpg'),
      fixture_path('alt_post_2.jpg'),
      fixture_path('alt_post_3.jpg'),
      fixture_path('alt_bg.jpg'),
      fixture_path('alt_pfp.jpg')
    ]
    click_button "Create Post"

    expect(page).to have_text "can't have more than 5 images"
  end

  scenario "doesn't allow user to post too big of a photo" do
    log_in_as(user)
    visit new_post_path

    fill_in "post_description", with: "Post title"
    attach_file "post_images", fixture_path('pfp_too_big.jpg')
    click_button "Create Post"

    expect(page).to have_text "Image 'pfp_too_big.jpg' is too large"
  end

  scenario "doesn't allow user to post without a photo" do
    log_in_as(user)
    visit new_post_path

    fill_in "post_description", with: "Post title"
    click_button "Create Post"

    expect(page).to have_text "An image must be attached."
  end

  scenario "doesn't allow user to post without description" do
    log_in_as(user)
    visit new_post_path

    attach_file "post_images", fixture_path('alt_post_0.jpg')
    click_button "Create Post"

    expect(page).to have_text "The description cannot be blank."
  end
end
