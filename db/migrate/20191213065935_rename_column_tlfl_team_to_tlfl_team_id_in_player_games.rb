class RenameColumnTlflTeamToTlflTeamIdInPlayerGames < ActiveRecord::Migration[5.2]
  def change
    rename_column :player_games, :tlfl_team, :tlfl_team_id
  end
end
