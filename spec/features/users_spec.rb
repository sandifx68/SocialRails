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
    # post login_path, params: { user_id: user.user_id, password: "password123" }
    # follow_redirect!
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

  scenario "allows logged user to modify own name" do
    log_in_as(user)
    visit user_path(user)

    expect(page).to have_content(user.display_name)
    editables.each do |e|
      expect(page).to have_selector("#edit-#{e}-link")
    end
  end

  scenario "doesn't show posts beloning to other user" do
    visit user_path(other_user)

    expect(page).to have_content(other_user.display_name)
    expect(page).to have_content("This user has no posts yet.")
  end
end
