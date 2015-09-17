require 'ipaddr'

class PingResult < ActiveRecord::Base
  VALID_IPADDR_REGEX = Regexp.union(IPAddr::RE_IPV4ADDRLIKE,
    IPAddr::RE_IPV6ADDRLIKE_FULL,
    IPAddr::RE_IPV6ADDRLIKE_COMPRESSED)
  validates_numericality_of :lag_ms, greater_than_or_equal_to: 0.0
  validates :src_addr, presence: true, format: { with: VALID_IPADDR_REGEX }
end
