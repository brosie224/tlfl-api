class ChangeStatsInProjectedPlayerGamesToFloats < ActiveRecord::Migration[5.2]
  def change
    change_column :projected_player_games, :pass_comp, :float
    change_column :projected_player_games, :pass_att, :float
    change_column :projected_player_games, :pass_yards, :float
    change_column :projected_player_games, :pass_td, :float
    change_column :projected_player_games, :pass_int, :float
    change_column :projected_player_games, :rushes, :float
    change_column :projected_player_games, :rush_yards, :float
    change_column :projected_player_games, :rush_td, :float
    change_column :projected_player_games, :receptions, :float
    change_column :projected_player_games, :rec_yards, :float
    change_column :projected_player_games, :rec_td, :float
    change_column :projected_player_games, :punt_ret_td, :float
    change_column :projected_player_games, :kick_ret_td, :float
    change_column :projected_player_games, :two_pt_pass, :float
    change_column :projected_player_games, :two_pt_rush, :float
    change_column :projected_player_games, :two_pt_rec, :float
    change_column :projected_player_games, :fgm, :float
    change_column :projected_player_games, :fga, :float
    change_column :projected_player_games, :pat, :float
  end
end
