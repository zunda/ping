class MeasureDistanceJob < ActiveJob::Base
  queue_as :low_priority

  # Measure distance in PingResult
  def perform(ping_result_id)
    ping_result = PingResult.find(ping_result_id)
    if ping_result and not ping_result.distance_km
      ping_result.measure_distance! and ping_result.save
    end
  end
end
