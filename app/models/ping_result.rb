require 'ipaddr'

class PingResult < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :location
  validates_numericality_of :lag_ms, greater_than_or_equal_to: 0.0
  validates :location_id, numericality: { only_integer: true }
  validates :server_location_id, numericality: { only_integer: true }
end
