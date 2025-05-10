require 'rails_helper'

RSpec.feature "Likes", type: :feature do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  def like_as(user)
    log_in_as(user)
    expect(page).to have_content(post.description)
    click_link "Like (0)"
  end

  scenario "can be added and removed by user", js: true do
    log_in_as(user)
    expect(page).to have_content(post.description)
    click_link "Like (0)"
    expect(page).to have_text "Like (1)"
    refresh
    expect(page).to have_text "Like (1)"
    click_link "Like (1)"
    expect(page).to have_text "Like (0)"
    refresh
    expect(page).to have_text "Like (0)"
  end

  scenario "can be added by multiple users", js: true do
    log_in_as(user)
    expect(page).to have_content(post.description)
    click_link "Like (0)"
    expect(page).to have_text "Like (1)"
    log_out
    log_in_as(other_user)
    click_link "Like (1)"
    expect(page).to have_text "Like (2)"
    refresh
    expect(page).to have_text "Like (2)"
  end

  scenario "cannot be added by unlogged user", js: true do
    visit root_path
    expect(page).to have_content(post.description)
    click_link "Like (0)"
    expect(page).to have_text "Like (0)"
    refresh
    expect(page).to have_text "Like (0)"
  end
end
