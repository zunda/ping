task 'ping_results:measure_distance' => :environment
namespace :ping_results do
  task :measure_distance do
    if Resque.size(:default) == 0
      MeasureDistanceJob.perform_later(
        PingResult.where(distance_km: nil).order(updated_at: :desc).map{|e| e.id}
      )
    end
  end
end
