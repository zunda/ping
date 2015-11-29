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
end
