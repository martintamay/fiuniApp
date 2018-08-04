require 'test_helper'

class AppReactControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get app_react_index_url
    assert_response :success
  end

end
