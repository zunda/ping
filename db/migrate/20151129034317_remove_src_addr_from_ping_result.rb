class RemoveSrcAddrFromPingResult < ActiveRecord::Migration
  def change
    remove_column :ping_results, :src_addr, :string
  end
end
