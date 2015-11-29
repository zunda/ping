class AddProtocolToPingResult < ActiveRecord::Migration
  def change
    add_column :ping_results, :protocol, :string
  end
end
