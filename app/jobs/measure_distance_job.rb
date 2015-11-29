class MeasureDistanceJob < ActiveJob::Base
  queue_as :default

  # Measure distance in PingResult
  def perform_later(ary)
    ary.each do |ping_result_id|
      ping_result = PingResult.find(ping_result_id)
      ping_result and ping_result.measure_distance! and ping_result.save
    end
  end
end
