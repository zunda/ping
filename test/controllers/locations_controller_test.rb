require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  setup do
    @location = locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should show location" do
    get :show, id: @location
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @location
    assert_response :success
  end

  test "should update location" do
    patch :update, id: @location, location: { city: @location.city, host: @location.host, latitude: @location.latitude, longitude: @location.longitude }
    assert_redirected_to location_path(assigns(:location))
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, id: @location
    end

    assert_redirected_to locations_path
  end

  test "should obtain new location when unknown" do
    @request.headers['X-Forwarded-For'] = '192.168.2.1'
    assert_difference('Location.count', 1) do
      get :current, format: :json
      assert_response :success
    end
  end

  test "should obtain new location when known location is old" do
    @request.headers['X-Forwarded-For'] = '192.168.1.2'
    assert_difference('Location.count', 1) do
      get :current, format: :json
      assert_response :success
    end
  end

  test "should obtain existing location when known" do
    # in test/fixtures/locations.yml, id: 1
    @request.headers['X-Forwarded-For'] = '192.168.1.1'
    assert_difference('Location.count', 0) do
      get :current, format: :json
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 1, json['id']
    end
  end

  test "should obtain latest location when known" do
    # in test/fixtures/locations.yml, id: 4 and 5
    @request.headers['X-Forwarded-For'] = '192.168.1.4'
    assert_difference('Location.count', 0) do
      get :current, format: :json
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 5, json['id']
    end
  end
end
