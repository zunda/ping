require 'test_helper'

class PingResultTest < ActiveSupport::TestCase
  ValidPingResult = {
    src_addr: "192.168.1.1",
    lag_ms: 123.45,
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

  test "src_addr should not be empty" do
    ping_result = PingResult.new(ValidPingResult.merge(src_addr: nil))
    assert_not ping_result.save, "Saved the ping_result without a valid src"
  end
end
