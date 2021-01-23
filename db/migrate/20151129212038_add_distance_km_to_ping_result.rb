class AddDistanceKmToPingResult < ActiveRecord::Migration[4.2]
  def change
    add_column :ping_results, :distance_km, :float
  end
end
