require 'test_helper'
require 'helpers/geocoder_stub'
require 'helpers/resolv_stub'

class GeocodeJobTest < ActiveJob::TestCase
  setup do
    @job = GeocodeJob.new
    @location = locations(:with_geocode_info)
  end

  test "location is not added when geocoding" do
    assert_difference('Location.count', 0) do
      @job.perform(id: @location.id, host: @location.host)
    end
  end
end
