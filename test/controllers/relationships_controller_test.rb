require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase

  # test to ensure new relationships require logged in users
  # and doesn't accidentally create new ones if you are not logged in.
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end
  
  # destroying relationships requires a logged in
  # user
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
  
end
