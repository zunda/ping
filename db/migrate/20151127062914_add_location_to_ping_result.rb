class AddLocationToPingResult < ActiveRecord::Migration[4.2]
  def change
    add_reference :ping_results, :location, index: true, foreign_key: true
  end
end
