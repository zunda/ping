class AddServerLocationIdToPingResult < ActiveRecord::Migration[4.2]
  def change
    add_column :ping_results, :server_location_id, :integer
  end
end
