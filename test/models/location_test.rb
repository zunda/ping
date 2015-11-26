require 'test_helper'
require 'helpers/geocoder_stub'
require 'helpers/resolv_stub'

class LocationTest < ActiveSupport::TestCase
  test "location is geocoded with city, longitude, and latitude" do
    l = Location.new(:city => 'foo', :longitude => 0.0, :latitude => 0.0)
    assert l.geocoded?, "Location with enough information shows not geocoded"
  end

  test "location is not geocoded without city" do
    l = Location.new(:city => nil, :longitude => 0.0, :latitude => 0.0)
    assert_not l.geocoded?, "Location without city shows geocoded"
  end

  test "location is not geocoded without coordinates" do
    l = Location.new(:city => 'foo', :longitude => nil, :latitude => nil)
    assert_not l.geocoded?, "Location without coordinate shows geocoded"
  end

  test "looking up an IP address should return a valid location" do
    l = Location.new(:host => '8.8.8.8')
    l.geocode_from_host!
    assert l.geocoded?, "Location with enough information shows not geocoded"
  end

  test "looking up a private IP address should not return a valid location" do
    l = Location.new(:host => '192.168.1.1')
    l.geocode_from_host!
    assert_not l.geocoded?, "Host with private IP address shows geocoded"
  end

  test "looking up FQDN shuold return a valid location" do
    l = Location.new(:host => 'www.google.com')
    l.geocode_from_host!
    assert l.geocoded?, "Host with FQDN shows not geocoded"
  end

  test "looking up a city name should return a valid location" do
    l = Location.new(:city => 'Paris, France')
    l.geocode_from_city!
    assert l.geocoded?, "City shows not geocoded"
  end

  test "looking up a private IP address with a city should return a valid location" do
    l = Location.new(:host => '192.168.1.1', :city => 'Paris, France')
    l.geocode!
    assert l.geocoded?, "Host with private IP address and a city shows not geocoded"
  end

  test "looking up a private IP address without a city should not return a valid location" do
    l = Location.new(:host => '192.168.1.1')
    l.geocode!
    assert_not l.geocoded?, "Host with private IP address without a city shows geocoded"
  end

  test "looking up a loopback IP address without a city should not return a valid location" do
    l = Location.new(:host => '127.0.0.1')
    l.geocode!
    assert_not l.geocoded?, "Host with loopback IP address without a city shows geocoded"
    assert_not l.latitude, "Host with loopback IP address without a city has a latitude"
    assert_not l.longitude, "Host with loopback IP address without a city has a longitude"
  end

  test "host should not be empty" do
    l = Location.new(:host => '')
    assert_not l.save, "Saved the location without a valid host"
  end

  test "expires after a while" do
    updated_at = Time.gm(2015, 11, 24, 4, 30)
    l = Location.new(:host => '127.0.0.1', :updated_at => updated_at)
    assert l.expired?(updated_at + Location::Expires_after + 1)
    assert_not l.expired?(updated_at)
  end
end
