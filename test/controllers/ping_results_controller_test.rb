require 'test_helper'

class PingResultsControllerTest < ActionController::TestCase
  setup do
    @ping_result = ping_results(:one)
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

  test "should create ping_result" do
    assert_difference('PingResult.count') do
      post :create, ping_result: { distance_km: @ping_result.distance_km, dst_addr: @ping_result.dst_addr, dst_city: @ping_result.dst_city, lag_ms: @ping_result.lag_ms, src_addr: @ping_result.src_addr, src_city: @ping_result.src_city }
    end

    assert_redirected_to ping_result_path(assigns(:ping_result))
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
    patch :update, id: @ping_result, ping_result: { distance_km: @ping_result.distance_km, dst_addr: @ping_result.dst_addr, dst_city: @ping_result.dst_city, lag_ms: @ping_result.lag_ms, src_addr: @ping_result.src_addr, src_city: @ping_result.src_city }
    assert_redirected_to ping_result_path(assigns(:ping_result))
  end

  test "should destroy ping_result" do
    assert_difference('PingResult.count', -1) do
      delete :destroy, id: @ping_result
    end

    assert_redirected_to ping_results_path
  end
end
