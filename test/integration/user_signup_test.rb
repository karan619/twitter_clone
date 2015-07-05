require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "Invalid Signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: "", email: 'user@invalid', password: 'foo', password_confirmation: 'bar' }
    end
    assert_template 'users/new'
  end

  test "Valid Sign up" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {name: 'examples', email: 'user@users.com', password: 'password', password_confirmation: 'password'}
    end
    assert_template 'users/show'
  end
end
