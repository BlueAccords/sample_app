require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test to ensure there is no difference in user count when trying to do a post command to 
  # register a user with invalid information
  # test success if user count shows no difference
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name:                    "",
                              email:       "user@invalid",
                              password:             "foo",
                              password_confirmation: "bar" }
      end
      assert_template 'users/new'
    end
  
  # test to ensure there IS a difference in user count by ONE(1) when
  # trying to do a post command to register with VALID information
  # test success if user count changes by 1.
  # also verfies the "show" template is shown on success
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {name: "Example User",
                                           email: "user@example.com",
                                           password: "password",
                                           password_confirmation: "password"}
    end
    # assert_template 'users/show'
    # assert is_logged_in?
  end
end
