class RemoveDistanceKmFromPingResults < ActiveRecord::Migration
  def change
    remove_column :ping_results, :distance_km, :float
  end
end
