module SessionHelpers
  def log_in_as(user, password: "password123")
    visit login_path
    fill_in "user_id", with: user.user_id
    fill_in "password", with: password
    click_button "Log In"
  end
end
