require 'rails_helper'

RSpec.feature "Posts update", type: :feature do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  # let(:other_user) { create(:user) }


  scenario "allows user to edit post" do
    log_in_as(user)

    expect(page).to have_text post.description
    click_button "..."
    click_link "Edit post"

    fill_in "post_description", with: "New title"
    click_button "Save changes"

    expect(page).to have_text "New title"
  end

  scenario "doesn't allow other user to edit or delete post" do
    log_in_as(other_user)

    expect(page).to have_text post.description
    click_button "..."
    expect(page).not_to have_text "Edit post"
    expect(page).not_to have_text "Delete post"
  end

  scenario "allows user to delete post", js: true do
    log_in_as(user)

    expect(page).to have_text post.description
    click_button "...", wait: 5
    click_link "Delete post", wait: 5
    click_button "OK", visible: :all, wait: 5
    refresh

    expect(page).not_to have_text post.description
  end
end
