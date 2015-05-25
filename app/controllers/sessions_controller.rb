class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #log the user in if email is found in the db as belonging to a user
      # AND(&&) if they can be authenticated with the correct password.
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      # create an error message
      render 'new'
    end
  end
  
  def destroy
  end
end