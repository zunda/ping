class RemoveDistanceKmFromPingResults < ActiveRecord::Migration[4.2]
  def change
    remove_column :ping_results, :distance_km, :float
  end
end
