class CreatePingResults < ActiveRecord::Migration
  def change
    create_table :ping_results do |t|
      t.float :lag_ms
      t.string :src_addr
      t.string :dst_addr
      t.string :src_city
      t.string :dst_city
      t.float :distance_km

      t.timestamps null: false
    end
  end
end
