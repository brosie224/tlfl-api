class ChangeTlflTeamIdInPlayerGameToInteger < ActiveRecord::Migration[5.2]
  def change
    # change_column :player_games, :tlfl_team_id, :integer
    change_column :player_games, :tlfl_team_id, :integer, using: 'tlfl_team_id::integer'
  end
end
