class GeocodeJob < ActiveJob::Base
  queue_as :default

  # Geocode location with :id - by :city when supplied or :host otherwise
  def perform(*args)
    h = args.last.is_a?(Hash) ? args.pop : {}
    location = Location.find(h[:id])
    if location
      if h[:city].blank?
        location.geocode_from_host!
      else
        location[:city] = h[:city]
        location.geocode_from_city!
      end
      location.save
    end
  end
end
