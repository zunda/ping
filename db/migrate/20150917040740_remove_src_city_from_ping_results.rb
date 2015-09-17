class RemoveSrcCityFromPingResults < ActiveRecord::Migration
  def change
    remove_column :ping_results, :src_city, :string
  end
end
