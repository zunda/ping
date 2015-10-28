require 'resolv'

class Location < ActiveRecord::Base
  include ApplicationHelper

  @@geocoder = Geocoder
  def Location::geocoder=(klass)
    @@geocoder = klass
  end

  @@resolver = Resolv
  def Location::resolver=(klass)
    @@resolver = klass
  end

  def geocode_from_host!
      ipaddress = host
      unless ipaddress =~ VALID_IPADDR_REGEX
        ipaddress = @@resolver.getaddress(ipaddress)
      end
      r = @@geocoder.search(ipaddress, ip_address: true).first
      if r
        self.city = r.address || r.city
        self.latitude = r.latitude
        self.longitude = r.longitude
      end
      return r
  end

  def geocode_from_city!
      r = @@geocoder.search(city).first
      if r
        self.city = r.address || r.city
        self.latitude = r.latitude
        self.longitude = r.longitude
      end
      return r
  end

  def geocoded?
    return false if self.city.blank?
    return false unless self.latitude.is_a?(Numeric)
    return false unless self.longitude.is_a?(Numeric)
    return true
  end
end
