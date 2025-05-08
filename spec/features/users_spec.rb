require 'rails_helper'

RSpec.describe "User show", type: :feature do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let(:editables) { [ "display-name", "description", "profile-photo", "background-image" ] }

  scenario "shows posts on user page" do
    visit user_path(user)

    expect(page).to have_content(user.display_name)
    expect(page).to have_content(post.description)
  end

  scenario "doesn't allow unlogged user to modify anything" do
    visit user_path(user)

    expect(page).to have_content(user.display_name)
    editables.each do |e|
      expect(page).not_to have_selector("#edit-#{e}-link")
    end
  end

  scenario "doesn't allow logged user to modify name others' names" do
    log_in_as(user)
    visit user_path(other_user)

    expect(page).to have_content(other_user.display_name)
    editables.each do |e|
      expect(page).not_to have_selector("#edit-#{e}-link")
    end
  end

  scenario "allows logged user to modify own editables" do
    log_in_as(user)
    visit user_path(user)

    expect(page).to have_content(user.display_name)
    editables.each do |e|
      expect(page).to have_selector("#edit-#{e}-link")
    end
  end

  scenario "user can modify name" do
    log_in_as(user)
    visit user_path(user)

    click_link(user.display_name)
    fill_in "user_display_name", with: "new_user_name"
    click_button "Save"
    expect(page).to have_content "new_user_name"
  end

  scenario "user can modify pfp" do
    log_in_as(user)
    visit user_path(user)

    img = page.find("img.profile-photo.profile-photo-editable")
    expected_src = ActionController::Base.helpers.asset_path("default_pfp.jpg")
    expect(img[:src]).to include(expected_src)
    click_link "edit-profile-photo-link"
    attach_file "user_profile_photo", Rails.root.join('spec', 'fixtures', 'files', 'alt_pfp.jpg')
    click_button "Save"
    img_new = page.find("img.profile-photo.profile-photo-editable")
    expect(img_new[:src]).to include("alt_pfp")
  end

  scenario "user can modify bg" do
    log_in_as(user)
    visit user_path(user)

    img = page.find("div.background-photo")[:style]
    expected_asset = ActionController::Base.helpers.asset_path("default_bg.jpg")
    expect(img).to include(expected_asset)
    click_link "edit-background-image-link"
    attach_file "user_background_image", Rails.root.join('spec', 'fixtures', 'files', 'alt_bg.jpg')
    click_button "Save"
    img_new = page.find("div.background-photo")[:style]
    expect(img_new).to include("alt_bg")
  end

  scenario "user cannot add too big of a pfp" do
    log_in_as(user)
    visit user_path(user)

    img = page.find("img.profile-photo.profile-photo-editable")
    expected_src = ActionController::Base.helpers.asset_path("default_pfp.jpg")
    expect(img[:src]).to include(expected_src)
    click_link "edit-profile-photo-link"
    attach_file "user_profile_photo", Rails.root.join('spec', 'fixtures', 'files', 'pfp_too_big.jpg')
    click_button "Save"
    expect(page).to have_content "Uploaded image is too large (max 5MB)"
  end

  scenario "user cannot add empty pfp" do
    log_in_as(user)
    visit user_path(user)

    img = page.find("img.profile-photo.profile-photo-editable")
    expected_src = ActionController::Base.helpers.asset_path("default_pfp.jpg")
    expect(img[:src]).to include(expected_src)
    click_link "edit-profile-photo-link"
    click_button "Save"
    expect(page).to have_content "Profile photo must be selected before uploading"
  end

  scenario "doesn't show posts beloning to other user" do
    visit user_path(other_user)

    expect(page).to have_content(other_user.display_name)
    expect(page).to have_content("This user has no posts yet.")
  end
end
