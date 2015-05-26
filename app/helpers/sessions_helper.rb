module SessionsHelper
  
  #logs in the given user with a temporary cookie.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  # Returns the current logged-in user (if there is one)
  def current_user
    # @current_user ||= User.find_by(id: session[:user_id])
    # temp session implementation ^
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
     # the tests still pass, so this branch is currently untested.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if a user is logged in, else false.
  def logged_in?
    !current_user.nil?
  end
  
  # Forgets a perisistent session by changing remember_digest value
  # and deleting id/remember token cookies
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # Logs the current user out.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
