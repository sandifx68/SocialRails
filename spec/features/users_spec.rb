require 'rails_helper'

RSpec.describe "User show", type: :feature do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  scenario "shows posts on user page" do
    visit user_path(user)

    expect(page).to have_content(user.display_name)
    expect(page).to have_content(post.description)
  end

  scenario "doesn't show posts beloning to other user" do
    visit user_path(other_user)

    expect(page).to have_content(other_user.display_name)
    expect(page).to have_content("This user has no posts yet.")
  end
end
