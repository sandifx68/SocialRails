require 'rails_helper'

RSpec.describe "User Sign Up", type: :request do
  let!(:user) { User.create(user_id: "test", display_name: "TestUser", password: "securepass", password_confirmation: "securepass") }

  it "creates a new user with valid details" do
    post users_path, params: { user: { user_id: "olasmg", display_name: "Ola Smigaj", password: "securepass", password_confirmation: "securepass" } }

    expect(response).to redirect_to(root_path)
    follow_redirect!

    expect(response.body).to include("Account created successfully!")
  end

  it "reject user with already existing display name" do
    post users_path, params: { user: { user_id: "test", display_name: "Ola Smigaj", password: "securepass", password_confirmation: "securepass" } }

    expect(CGI.unescapeHTML(response.body)).to include("User has already been taken")
  end

  it "rejects a new user with different confirmation password" do
    post users_path, params: { user: { user_id: "olasmg", display_name: "Ola Smigaj", password: "securepass", password_confirmation: "blah" } }

    expect(CGI.unescapeHTML(response.body)).to include("Password confirmation doesn't match Password")
  end

  it "rejects sign up with missing password" do
    post users_path, params: { user: { display_name: "TestUser", password: "", password_confirmation: "" } }

    expect(CGI.unescapeHTML(response.body)).to include("Password can't be blank")
  end
end
