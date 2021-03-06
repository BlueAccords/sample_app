class UsersController < ApplicationController
   before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                         :following, :followers]
   before_action :correct_user,   only: [:edit, :update]
   before_action :admin_user,     only: :destroy
  # execute show method defined in app/views/users/show.html.erb
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # debugger
    # used to debug a section of code in the console while the app is running
  end
  
  def new
    @user = User.new
  end
  
  # Create a new user and send them an activation email.
  def create 
    @user = User.new(user_params) # not the final implementation.
    if @user.save
      # if user.save == true, handle a successful save
      # flash a temporary message. success == successful result
      
      # new implementation with account activation
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      
      # old implementation with no account activation
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # automatically infers @user == user_url(@user)
      # redirect_to @user
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
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
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
  # def logged_in_user
  #   unless logged_in?
  #     store_location
  #     flash[:danger] = "Please log in."
  #     redirect_to login_url
  #   end
  # end
  
  # Confirms the correct user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
