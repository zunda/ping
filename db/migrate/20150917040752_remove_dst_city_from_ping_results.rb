class RemoveDstCityFromPingResults < ActiveRecord::Migration
  def change
    remove_column :ping_results, :dst_city, :string
  end
end
