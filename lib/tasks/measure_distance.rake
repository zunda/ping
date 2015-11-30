task 'ping_results:measure_distance' => :environment
namespace :ping_results do
  task :measure_distance do
    print "ping_results:measure_distance - "
    s = Resque.size(:default)
    puts "Reque.size(:default) is #{s}"
    if s == 0
      PingResult.where(distance_km: nil).order(updated_at: :desc).each do |ping_result|
        MeasureDistanceJob.perform_later(ping_result.id)
      end
    else
      puts "Skip queuing for now"
    end
  end
end
