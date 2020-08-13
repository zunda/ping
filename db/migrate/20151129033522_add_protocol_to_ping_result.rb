class AddProtocolToPingResult < ActiveRecord::Migration[4.2]
  def change
    add_column :ping_results, :protocol, :string
  end
end
