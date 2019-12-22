class ChangeProjectedStatsToFloats < ActiveRecord::Migration[5.2]
  def change
    change_column :projected_team_dst_games, :points_allowed, :float
    change_column :projected_team_dst_games, :touchdowns, :float
    change_column :projected_team_dst_games, :sacks, :float
    change_column :projected_team_dst_games, :fumbles_recovered, :float
    change_column :projected_team_dst_games, :interceptions, :float
    change_column :projected_team_dst_games, :safeties, :float
    change_column :projected_team_dst_games, :two_pt_ret, :float
  end
end
