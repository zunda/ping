class GeocodeJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    h = args.last.is_a?(Hash) ? args.pop : {}
    location = Location.find(h[:id])
    if location
      location.geocode!
      location.save
    end
  end
end
