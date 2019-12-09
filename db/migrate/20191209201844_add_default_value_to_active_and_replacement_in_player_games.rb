class AddDefaultValueToActiveAndReplacementInPlayerGames < ActiveRecord::Migration[5.2]
  def change
    change_column_default :player_games, :active, true
    change_column_default :player_games, :needs_replacement, false
  end
end
