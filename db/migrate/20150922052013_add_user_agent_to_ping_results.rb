class AddUserAgentToPingResults < ActiveRecord::Migration[4.2]
  def change
    add_column :ping_results, :user_agent, :string
  end
end
