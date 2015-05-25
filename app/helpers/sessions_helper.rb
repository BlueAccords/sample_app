module SessionsHelper
  
  #logs in the given user with a temporary cookie.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Returns the current logged-in user (if there is one)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  # Returns true if a user is logged in, else false.
  def logged_in?
    !current_user.nil?
  end
end
