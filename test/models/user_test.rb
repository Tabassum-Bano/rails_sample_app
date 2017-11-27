require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user=User.new(name: "Tabassum", email: "tabassum.bano@payu.in",password: "foobar",password_confirmation: "foobar")
	end

	test "test validation of attributes" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name=" "
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email=" "
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name="a"*51
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email="a"*244 +"@example.com"
		assert_not @user.valid?
	end

	test "email should accept valid email" do
		valid_addresses = %w[user@example.com USER@fo.com A_USe-r@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |valid_address|
			@user.email=valid_address
			assert @user.valid?, "#{valid_address.inspect} should be valid"
		end
	end

	test "email should reject invalid email" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
		invalid_addresses.each do |invalid_address|
			@user.email=invalid_address
			assert_not @user.valid?, "#{invalid_address} should be invalid"
		end
	end

	test "email address should be unique" do
		duplicate_user=@user.dup
		duplicate_user.email=@user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email address should be stored with lower case letters" do
		user_email="Fooebar@exAmple.com"
		@user.email=user_email
		@user.save
		assert_equal user_email.downcase,@user.reload.email
	end

	test "password should not be blank" do
		@user.password=@user.password_confirmation="     "
		assert_not @user.valid?
	end

	test "password minimum length should be 6" do
		@user.password_confirmation=@user.password="a"*5
		assert_not @user.valid?
	end



  # test "the truth" do
  #   assert true
  # end
end
