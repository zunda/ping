class PingResult < ActiveRecord::Base
  validates_numericality_of :lag_ms, greater_than_or_equal_to: 0.0
  validates :src_addr, presence: true, allow_blank: false
  validates :dst_addr, presence: true, allow_blank: false
end
