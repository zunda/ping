require 'test_helper'

class GeocodeJobMock
  attr_reader :calls_to

  def initialize
    @calls_to = Hash.new{|h, k| h[k] = 0}
  end

  def perform_later(*args)
    called(__method__)
  end

  private
    def called(method_name)
      @calls_to[method_name] += 1
    end
end

class LocationsControllerTest < ActionController::TestCase
  setup do
    LocationsController::geocodejob = GeocodeJobMock.new
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
    city_new = @location.city + "X"
    @request.headers['X-Forwarded-For'] = @location.host
    patch :update, id: @location, location: { city: city_new, host: @location.host, latitude: @location.latitude, longitude: @location.longitude }
    assert_redirected_to location_path(assigns(:location))
    @location.reload
    assert_equal city_new, @location.city
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, id: @location
    end

    assert_redirected_to locations_path
  end

  test "should obtain new location when unknown" do
    @request.headers['X-Forwarded-For'] = '192.168.2.1'
    assert_difference("LocationsController::geocodejob.calls_to[:perform_later]", 1) do
      assert_difference('Location.count', 1) do
        get :current, format: :json
        assert_response :success
      end
    end
  end

  test "should obtain new location when known location is old" do
    @request.headers['X-Forwarded-For'] = '192.168.1.2'
    assert_difference("LocationsController::geocodejob.calls_to[:perform_later]", 1) do
      assert_difference('Location.count', 1) do
        get :current, format: :json
        assert_response :success
      end
    end
  end

  test "should obtain existing location when known" do
    # in test/fixtures/locations.yml, id: 1
    @request.headers['X-Forwarded-For'] = '192.168.1.1'
    assert_difference("LocationsController::geocodejob.calls_to[:perform_later]", 0) do
      assert_difference('Location.count', 0) do
        get :current, format: :json
        assert_response :success
        json = JSON.parse(response.body)
        assert_equal 1, json['id']
        assert_equal @request.headers['X-Forwarded-For'], json['host']
      end
    end
  end

  test "should obtain latest location when known" do
    # in test/fixtures/locations.yml, id: 4 and 5
    assert_difference("LocationsController::geocodejob.calls_to[:perform_later]", 0) do
      @request.headers['X-Forwarded-For'] = '192.168.1.4'
      assert_difference('Location.count', 0) do
        get :current, format: :json
        assert_response :success
        json = JSON.parse(response.body)
        assert_equal 5, json['id']
      end
    end
  end

  test "should obtain server location when known" do
  # in test/fixtures/locations.yml, id: 6
  @request.headers['HTTP_HOST'] = 'www.example.com'
    assert_difference('Location.count', 0) do
      get :server, format: :json
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 6, json['id']
      assert_equal @request.headers['HTTP_HOST'], json['host']
    end
  end
end
