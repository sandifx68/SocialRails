require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  def post_comment_as(user)
    log_in_as(user)
    expect(page).to have_content(post.description)
    click_link "Comment (0)"

    fill_in "comment-form", with: "Nice photo!"
    page.find("#post-comment-button").click
    expect(page).to have_text("Comment added.")
    expect(page).to have_text(": Nice photo!")
  end

  scenario "can be posted by user who posted" do
    post_comment_as(user)
  end

  scenario "can be posted by other user" do
    post_comment_as(other_user)
  end

  scenario "can be deleted by who posted comment" do
    post_comment_as(user)
    page.find("#commentDropdown").click()
    click_link "Delete comment"

    expect(page).to have_text "deleted!"
    expect(page).not_to have_text "Nice photo!"
  end

  scenario "cannot be posted if empty" do
    log_in_as(user)
    expect(page).to have_content(post.description)
    click_link "Comment (0)"
    page.find("#post-comment-button").click

    expect(page).to have_text("cannot be blank")
    expect(page).not_to have_text(user.display_name+":")
  end

  scenario "cannot be posted if not logged in" do
    visit root_path

    expect(page).to have_content(post.description)
    click_link "Comment (0)"

    expect(page).not_to have_content("#comment-form")
  end

  scenario "cannot be destroyed if not logged in" do
    post_comment_as(user)
    log_out

    expect(page).to have_content(post.description)
    click_link "Comment (1)"

    page.find("#commentDropdown").click()
    expect(page).to have_content("View Profile")
    expect(page).not_to have_content("Delete comment")
  end

  scenario "cannot be destroyed by other user" do
    post_comment_as(user)
    log_out
    log_in_as(other_user)

    expect(page).to have_content(post.description)
    click_link "Comment (1)"

    page.find("#commentDropdown").click()
    expect(page).to have_content("View Profile")
    expect(page).not_to have_content("Delete comment")
  end
end
