require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test micropost has valid user, and within valid
  # content length
  
  def setup
    @user = users(:michael)
    # This code is not idiomatically correct
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
  
  test "micropost should be valid" do
    assert @micropost.valid?
  end
  
  test "user id should be present, invalid micropost" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "micropost content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end
  
  test "content should be at most 140 char" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "order of posts should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
