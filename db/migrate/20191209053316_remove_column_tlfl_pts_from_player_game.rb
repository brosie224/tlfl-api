class RemoveColumnTlflPtsFromPlayerGame < ActiveRecord::Migration[5.2]
  def change
    remove_column :player_games, :tlfl_pts
  end
end
