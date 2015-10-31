class GeocodeJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    location = Location.new(*args)
    location.geocode!
    location.save
  end
end
