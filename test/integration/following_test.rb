require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end
  
  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    # converting number of ppl user is following to string and
    # looking for it in the view somewhere
    assert_match @user.following.count.to_s, response.body
    # checks each user in the following array
    # for a profile link
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    # converting number of ppl user is following to string and
    # looking for it in the view somewhere
    assert_match @user.followers.count.to_s, response.body
    # checks each user in the following array
    # for a profile link
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
end
