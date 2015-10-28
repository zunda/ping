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
    obtain_geocode_result(r)
    return r
  end

  def geocode_from_city!
    r = @@geocoder.search(city).first
    obtain_geocode_result(r)
    return r
  end

  def geocode!
    r = geocode_from_host!
    if not geocoded? and not city.blank?
      r = geocode_from_city!
    end
    return r
  end

  def geocoded?
    return false if self.city.blank?
    return false unless self.latitude.is_a?(Numeric)
    return false unless self.longitude.is_a?(Numeric)
    return true
  end

  private
  def obtain_geocode_result(result)
    if result
      if not result.address.blank?
        self.city = result.address
      elsif not result.city.blank?
        self.city = result.city
      end
      self.latitude = result.latitude
      self.longitude = result.longitude
    end
  end
end
