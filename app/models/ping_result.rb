require 'ipaddr'

class PingResult < ActiveRecord::Base
  include ApplicationHelper
  validates_numericality_of :lag_ms, greater_than_or_equal_to: 0.0
  validates :src_addr, presence: true, format: { with: VALID_IPADDR_REGEX }
end
