require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should know other host of this app" do
    get :index
    assert response.body =~ /ping-us.herokuapp.com/, \
      'Does not know about other host'
  end

  test "should exclude self from other host of this app" do
    @request.host = 'ping-us.herokuapp.com'
    get :index
    assert_not response.body =~ /ping-us.herokuapp.com/, \
      'Other host includes self'
  end
end
