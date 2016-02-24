module ApplicationHelper
  VALID_IPADDR_REGEX = Regexp.union(IPAddr::RE_IPV4ADDRLIKE,
    IPAddr::RE_IPV6ADDRLIKE_FULL,
    IPAddr::RE_IPV6ADDRLIKE_COMPRESSED)

  def apps_hosts
    hosts = %w(us eu).map{|region| "ping-#{region}.herokuapp.com"}
    if request and not request.host.blank?
      hosts.reject!{|host| host == request.host}
    end
    return hosts
  end
end
