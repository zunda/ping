class AddDistanceKmToPingResult < ActiveRecord::Migration
  def change
    add_column :ping_results, :distance_km, :float
  end
end
