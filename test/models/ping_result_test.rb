require 'test_helper'

class PingResultTest < ActiveSupport::TestCase
  ValidPingResult = {
    lag_ms: 123.45,
    location_id: 67,
    server_location_id: 89,
  }

  test "lag should not be nil" do
    ping_result = PingResult.new(ValidPingResult.merge(lag_ms: nil))
    assert_not ping_result.save, "Saved the ping_result without a valid lag"
  end

  test "lag can be 0" do
    ping_result = PingResult.new(ValidPingResult.merge(lag_ms: 0.0))
    assert ping_result.save, "Did not save the ping_result with a 0 lag"
  end

  test "lag can be more than 0" do
    ping_result = PingResult.new(ValidPingResult)
    assert ping_result.save, "Did not save the ping_result with a positive lag"
  end

  test "has to have a location" do
    ping_result = PingResult.new
    ping_result.location_id = nil
    assert_not ping_result.save, "Saved the ping_result without a valid location"
  end

  test "has to have a server location" do
    ping_result = PingResult.new
    ping_result.server_location_id = nil
    assert_not ping_result.save, "Saved the ping_result without a valid server location"
  end

  test "calculates distance" do
    ping_result = PingResult.new
    # Locations defined in test/fixtures/locations.yml
    ping_result.location_id = locations(:equator).id
    ping_result.server_location_id = locations(:north_pole).id
    assert_in_delta 10000, ping_result.distance, 10, "Distance between equator and north pole is not about 10000 km"
  end

  test "records distance" do
    ping_result = PingResult.new
    ping_result.lag_ms = 1.0
    # Locations defined in test/fixtures/locations.yml
    ping_result.location_id = locations(:equator).id
    ping_result.server_location_id = locations(:north_pole).id
    ping_result.measure_distance!
    assert ping_result.save, "Did not save distance"
    assert_in_delta 10000, ping_result.distance_km, 10, "Recorded distance between equator and north pole is not about 10000 km"
  end

  test "does not calculate distance without location" do
    ping_result = PingResult.new
    # Locations defined in test/fixtures/locations.yml
    ping_result.location_id = locations(:nowhere).id
    ping_result.server_location_id = locations(:somewhere).id
    assert_nil ping_result.distance, "Distance is calculated for nowhere"
  end
end
