require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "example", email: "example@example.com", password: "password", password_confirmation: "password" )
  end

  test "Error for nil digest" do
    assert_not @user.authenticated?('')
  end
  
  test "User must be valid" do
    assert @user.valid?
  end

  test "User name has to be present" do
    xxx = ["", "    ", " "]
    xxx.each do |x|
      @user.name = x
      assert_not @user.valid?
    end
  end

  test "User email must be valid" do
    xxx = ["", "    ", " "]
    xxx.each do |x|
      @user.email = x
      assert_not @user.valid?
    end 
  end

  test "Name too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "Email too long" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.us alice+bob@baz.in]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "No duplicates allowed" do
    dup = @user.dup
    dup.email = @user.email.upcase
    @user.save
    assert_not dup.valid?
  end

  test "password cannot be blank" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  test "password minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  test "Email Must be downcased before save!" do
    mix = "AbCjsndE@ExAmPle.CoM"
    @user.email = mix
    @user.save
    assert_equal mix.downcase, @user.reload.email
  end
end
