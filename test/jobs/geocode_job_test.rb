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

  test "location is geocoded with host when city is not specified" do
    @job.perform(id: @location.id)
    @location.reload
    assert_equal 'Mountain View, CA 94040, United States', @location.city
    # define in test/helpers/geocoder_stub.rb
  end

  test "location is geocoded with city when city is specified" do
    @job.perform(id: @location.id, city: 'Paris, France')
    @location.reload
    assert_equal 'Paris, FR', @location.city
    # define in test/helpers/geocoder_stub.rb
  end
end

