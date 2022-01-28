class AddOpponentNameToTeamEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :team_events, :opponent_name, :string
  end
end
