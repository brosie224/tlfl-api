class AddDefaultForByePtsInPlayerGames < ActiveRecord::Migration[5.2]
  def change
    change_column_default :player_games, :bye_pts, 0
  end
end
