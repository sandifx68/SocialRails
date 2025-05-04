require 'rails_helper'

RSpec.describe "User Login", type: :request do
  let!(:user) { User.create(user_id: "test", display_name: "TestUser", password: "securepass", password_confirmation: "securepass") }

  it "logs in successfully with correct credentials" do
    post login_path, params: { user_id: "test", password: "securepass" }

    expect(session[:user_id]).to eq(user.id)
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include("TestUser")
  end

  it "fails login with incorrect password" do
    post login_path, params: { user_id: "test", display_name: "TestUser", password: "wrongpass" }

    expect(session[:user_id]).to be_nil
    expect(response.body).to include("Invalid display name or password")
  end
end
