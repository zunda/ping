class RemoveDstAddrFromPingResults < ActiveRecord::Migration
  def change
    remove_column :ping_results, :dst_addr, :string
  end
end
