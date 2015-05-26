class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  # execute show method defined in app/views/users/show.html.erb
  def show
    @user = User.find(params[:id])
    # debugger
    # used to debug a section of code in the console while the app is running
  end
  
  def new
    @user = User.new
  end
  
  def create 
    @user = User.new(user_params) # not the final implementation.
    if @user.save
      # if user.save == true, handle a successful save
      # flash a temporary message. success == successful result
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      # automatically infers @user == user_url(@user)
      redirect_to @user
    else
      # refresh the sign up page and indicate what needs
      # to be changed
      render 'new'
    end
  end
  
  # find current user by ID.
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Successfully Updated"
      redirect_to @user
      #handle a successful update.
    else
      render 'edit'
    end
  end
  
  private
  
  def user_params
    # defines parameters required(user) and
    # parameters permitted (name, email pw, pw confirm)
    # and disallows other mass of parameters to be
    # more secure.
    params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
  end
  
  #Before filters
  
  # confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
