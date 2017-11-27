require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
	def setup
		@base_title="Ruby on Rails"
	end
	
  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", "SignUp | #{@base_title}"
  end

end
