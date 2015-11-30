require 'test_helper'

class MeasureDistanceJobTest < ActiveJob::TestCase
  setup do
    @job = MeasureDistanceJob.new
    @ping_result = PingResult.new
    @ping_result.lag_ms = 1.0
    # Locations defined in test/fixtures/locations.yml
    @ping_result.location_id = locations(:equator).id
    @ping_result.server_location_id = locations(:north_pole).id
    assert @ping_result.save, "Did not save the PingResult to be tested"
  end

  test "distance is measured" do
    @job.perform(@ping_result.id)
    @ping_result.reload
    assert_in_delta 10000, @ping_result.distance_km, 10, "Recorded distance between equator and north pole is not about 10000 km"
  end
end

