require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:karan)
    @non_admin = users(:test)
  end

  test "Get the index page as admin with pagination and delete" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select "div", class: "pagination"
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name 
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'Delete', class: 'badge'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end 
  end

  test "should not delete user as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
