class Location < ActiveRecord::Base
  @@geocoder = Geocoder
  def Location::geocoder=(klass)
    @@geocoder = klass
  end

  def geocode_from_host!
      # TODO: convert FQDN into IP address
      r = @@geocoder.search(host, ip_address: true).first
      if r
        self.city = r.address
        self.latitude = r.latitude
        self.longitude = r.longitude
      end
      return r
  end
end
