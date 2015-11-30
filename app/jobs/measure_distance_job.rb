class MeasureDistanceJob < ActiveJob::Base
  queue_as :low_priority

  # Measure distance in PingResult
  def perform(ary)
    ary.each do |ping_result_id|
      ping_result = PingResult.find(ping_result_id)
      unless ping_result.distance_km
        ping_result and ping_result.measure_distance! and ping_result.save
      end
    end
  end
end
