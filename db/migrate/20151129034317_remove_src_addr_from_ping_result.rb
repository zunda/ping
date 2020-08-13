class RemoveSrcAddrFromPingResult < ActiveRecord::Migration[4.2]
  def change
    remove_column :ping_results, :src_addr, :string
  end
end
