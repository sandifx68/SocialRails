require 'rails_helper'

RSpec.feature "Posts index", type: :feature do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  scenario "shows post on index" do
    visit posts_path

    expect(page).to have_content(user.display_name)
    expect(page).to have_content(post.description)
    expect(page).to have_content("less than a minute ago")
  end
end
