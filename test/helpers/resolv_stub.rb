class ResolvStub
  PreparedResponses = {
    'www.google.com' => '216.58.216.4'
  }

  def self::getaddress(ipaddress)
    return PreparedResponses[ipaddress]
  end
end

# Use stubs instead of real external resources
Location::resolver = ResolvStub
