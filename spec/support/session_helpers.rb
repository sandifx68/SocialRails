module SessionHelpers
  def log_in_as(user, password: "complicatedPassword123GoogleBreach")
    visit login_path
    fill_in "user_id", with: user.user_id
    fill_in "password", with: password
    click_button "Log In"
    expect(page).to have_text("successfully!")
  end

  def image_path(filename)
    Rails.root.join('app', 'assets', 'images', 'demo_images', filename)
  end
end
