class AddDefaultForAllPlayerStats < ActiveRecord::Migration[5.2]
  def change
    change_column_default :player_games, :pass_comp, 0
    change_column_default :player_games, :pass_att, 0
    change_column_default :player_games, :pass_yards, 0
    change_column_default :player_games, :pass_td, 0
    change_column_default :player_games, :pass_int, 0
    change_column_default :player_games, :rushes, 0
    change_column_default :player_games, :rush_yards, 0
    change_column_default :player_games, :rush_td, 0
    change_column_default :player_games, :receptions, 0
    change_column_default :player_games, :rec_yards, 0
    change_column_default :player_games, :rec_td, 0
    change_column_default :player_games, :punt_ret_td, 0
    change_column_default :player_games, :kick_ret_td, 0
    change_column_default :player_games, :two_pt_pass, 0
    change_column_default :player_games, :two_pt_rush, 0
    change_column_default :player_games, :two_pt_rec, 0
    change_column_default :player_games, :fgm, 0
    change_column_default :player_games, :fga, 0
    change_column_default :player_games, :pat, 0
  end
end
