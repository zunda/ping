class AddServerLocationIdToPingResult < ActiveRecord::Migration
  def change
    add_column :ping_results, :server_location_id, :integer
  end
end
