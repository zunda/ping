class RemoveDstAddrFromPingResults < ActiveRecord::Migration[4.2]
  def change
    remove_column :ping_results, :dst_addr, :string
  end
end
