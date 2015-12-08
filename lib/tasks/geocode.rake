task 'locations:geocode' => :environment
namespace :locations do
  task :geocode do
    print "locations:geocode - "
    s = Resque.size(:default)
    puts "Reque.size(:default) is #{s}"
    if s == 0
      Location.where("city IS NULL OR city = ''").order(updated_at: :desc).each do |location|
        GeocodeJob.perform_later(id: location.id)
      end
    else
      puts "Skip queuing for now"
    end
  end
end
