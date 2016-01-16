require 'test_helper'

class DsoControllerTest < ActionController::TestCase
  test "should get echo" do
    get :echo
    assert_response :success
  end

end
