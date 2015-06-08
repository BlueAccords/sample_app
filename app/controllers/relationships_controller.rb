class RelationshipsController < ApplicationController
  # check to make sure actions are only run on relationship controller
  # if user is logged in.
  before_action :logged_in_user
  
  # find user by id then follow.
  def create
   @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # only html or js will be ran
    # similar to if/else statement
    # responds depending on type request(html or javascript)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  #find user id then unfollow
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
