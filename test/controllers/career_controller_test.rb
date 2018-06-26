require 'test_helper'

class CareerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get career_index_url
    assert_response :success
  end

end
