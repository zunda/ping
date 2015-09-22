class AddUserAgentToPingResults < ActiveRecord::Migration
  def change
    add_column :ping_results, :user_agent, :string
  end
end
