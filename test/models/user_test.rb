require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  #this test is to see if a whitespaced name validates to false.
  # and will only pass if an empty name is invalid.
  test "name should be present" do
    assert @user.name = "      "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    assert @user.email = "      "
    assert_not @user.valid?
  end
  
  test "name should not be longer than x characters" do
    assert @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be longer than x characters" do 
    assert @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should only accept valid emails" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      
      @user.email = valid_address
      # custom error message after the @user.valid? check.
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid emails" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. 
                            foo@bar_baz.com foo@bar+bz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid? "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    # upcase to test against the original lower case
    # to make sure the email addresses are unique even when in different cases.
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "password should have minimum length" do 
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil pw digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed on user destroy" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  # test "the truth" do
  #   assert true
  # end
end
