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

  test "should not create ping_result without proper HTTP header" do
    assert_no_difference('PingResult.count') do
      post :create, ping_result: { lag_ms: @ping_result.lag_ms, src_addr: @ping_result.src_addr }
    end
  end

  test "should create ping_result with X-Forwarded-For" do
    ipaddr = '8.9.10.11'
    @request.headers['X-Forwarded-For'] = ipaddr
    @request.headers['REMOTE_ADDR'] = '192.168.1.1'
    assert_difference('PingResult.count') do
      post :create, ping_result: { lag_ms: @ping_result.lag_ms, src_addr: @ping_result.src_addr }
    end

    assert_redirected_to ping_result_path(assigns(:ping_result))
    assert_equal ipaddr, PingResult.last.src_addr
  end

  test "should create ping_result with REMOTE_ADDR" do
    ipaddr = '9.10.11.12'
    @request.headers['REMOTE_ADDR'] = ipaddr
    assert_difference('PingResult.count') do
      post :create, ping_result: { lag_ms: @ping_result.lag_ms, src_addr: @ping_result.src_addr }
    end

    assert_redirected_to ping_result_path(assigns(:ping_result))
    assert_equal ipaddr, PingResult.last.src_addr
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
