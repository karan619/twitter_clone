require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
	def setup
		ActionMailer::Base.deliveries.clear
		@user = users(:karan)
	end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid Email
    post password_resets_path, password_reset: {email: ""}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Vaild email
    post password_resets_path, password_reset: {email: @user.email}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # catch the user from create action of controller
    user = assigns(:user)
    # check with wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Check the Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # right email, wrong token
    get edit_password_reset_path('a wrong token', email: user.email)
    assert_redirected_to root_url
    # right email and token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password and confirmation
    patch password_reset_path(user.reset_token), email: user.email, user: {password: 'foobar', password_confirmation: "abcxyz"}
    assert_select 'div', class: 'alert'
    # Empty password and confirmation
    patch password_reset_path(user.reset_token), email: user.email, user: {password: "", password_confirmation: ""}
    assert_not flash.empty?
    assert_template "password_resets/edit"
    # valid password and confirmation
    patch password_reset_path(user.reset_token), email: user.email, user:{password: 'password', password_confirmation: 'password'}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
