module ApplicationHelper
  def current_user?
    session[:user_id] == @user.id
  end
end
