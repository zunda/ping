require 'test_helper'

class PingResultsControllerTest < ActionController::TestCase
  setup do
    @ping_result = ping_results(:one)
    @request.headers['X-Forwarded-For'] = nil
    @request.headers['REMOTE_ADDR'] = nil
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ping_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should record User-Agent if supplied" do
    user_agent = "Test browser"
    @request.user_agent = user_agent
    ipaddr = '9.10.11.12'
    @request.headers['REMOTE_ADDR'] = ipaddr

    assert_difference('PingResult.count') do
      post :create, ping_result: {
        lag_ms: @ping_result.lag_ms,
        user_agent: @ping_result.user_agent,
        location_id: @ping_result.location_id,
        server_location_id: @ping_result.server_location_id
      }
    end

    assert_redirected_to ping_result_path(assigns(:ping_result))
    assert_equal user_agent, PingResult.last.user_agent
  end

  test "should belong to a location" do
    ping_result = ping_results(:location_test)
    assert_difference('PingResult.count') do
      post :create, ping_result: {
        lag_ms: ping_result.lag_ms,
        location_id: ping_result.location_id,
        server_location_id: ping_result.server_location_id
      }
    end
    assert PingResult.last.location
    assert_equal PingResult.last,  PingResult.last.location.ping_results.last
  end

  test "should record the server" do
    ping_result = ping_results(:location_test)
    assert_difference('PingResult.count') do
      post :create, ping_result: {
        lag_ms: ping_result.lag_ms,
        location_id: ping_result.location_id,
        server_location_id: 42
      }
    end
    assert_equal 42, PingResult.last.server_location_id
  end

  test "should record the procotol" do
    assert @request.protocol, "protocol is not set"
    assert_difference('PingResult.count') do
      post :create, ping_result: {
        lag_ms: @ping_result.lag_ms,
        location_id: @ping_result.location_id,
        server_location_id: @ping_result.server_location_id
      }
    end
    assert_equal @request.protocol, PingResult.last.protocol
  end

  test "should show ping_result" do
    get :show, id: @ping_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ping_result
    assert_response :success
  end

  test "should update ping_result" do
    patch :update, id: @ping_result, ping_result: { lag_ms: @ping_result.lag_ms }
    assert_redirected_to ping_result_path(assigns(:ping_result))
  end

  test "should destroy ping_result" do
    assert_difference('PingResult.count', -1) do
      delete :destroy, id: @ping_result
    end

    assert_redirected_to ping_results_path
  end
end
