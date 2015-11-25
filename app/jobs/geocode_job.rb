class GeocodeJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    location = Location.new(*args)
    location.geocode!
    location.save	# TODO: update if possible
  end
end
