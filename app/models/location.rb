require 'resolv'

class Location < ActiveRecord::Base
  include ApplicationHelper
  validates :host, presence: true

  Expires_after = 86400 # sec

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
    logger.info "Geocoded from host: #{r.inspect}" if r
    obtain_geocode_result(r) if r and r.respond_to?(:data) and r.data['ip']
    # IP address is assumed to be geocoded if there is 'ip' set
    return r
  end

  def geocode_from_city!
    r = @@geocoder.search(city).first
    logger.info "Geocoded from city: #{r.inspect}" if r
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

  def expired?(time = Time.now)
    return false unless self.updated_at
    return false if self.updated_at > time - Location::Expires_after
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
