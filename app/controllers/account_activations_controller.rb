class AccountActivationsController < ApplicationController
  
  # Finds user by email and checks to see if
  # 1. user is found, 2. user is NOT activated already, 3. user's activation token and email are correct in the db.
  # if true to all activate account and update attributes and log user in.
  # else redirect to front page and give error message.
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
