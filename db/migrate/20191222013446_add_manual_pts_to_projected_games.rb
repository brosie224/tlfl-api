class AddManualPtsToProjectedGames < ActiveRecord::Migration[5.2]
  def change
    add_column :projected_player_games, :manual_pts, :integer
    add_column :projected_team_dst_games, :manual_pts, :integer
  end
end
