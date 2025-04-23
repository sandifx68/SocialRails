class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :current_user?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Check whether the currently authentified user is also the
  # user in the view
  def current_user?(user = nil)
    puts "test"
    user ||= @user  # Fallback to instance variable if not passed
    current_user && current_user == user
  end
end
