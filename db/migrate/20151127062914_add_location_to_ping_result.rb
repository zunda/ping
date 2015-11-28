class AddLocationToPingResult < ActiveRecord::Migration
  def change
    add_reference :ping_results, :location, index: true, foreign_key: true
  end
end
