class SetDefaultsForTeamDstGames < ActiveRecord::Migration[5.2]
  def change
    change_column_default :team_dst_games, :points_allowed, 99
    change_column_default :team_dst_games, :touchdowns, 0
    change_column_default :team_dst_games, :sacks, 0
    change_column_default :team_dst_games, :fumbles_recovered, 0
    change_column_default :team_dst_games, :interceptions, 0
    change_column_default :team_dst_games, :safeties, 0
    change_column_default :team_dst_games, :two_pt_ret, 0
  end
end
