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
        self.city = r.address
        self.latitude = r.latitude
        self.longitude = r.longitude
      end
      return r
  end
end
