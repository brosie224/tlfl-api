class AddManualPtsToPlayerGame < ActiveRecord::Migration[5.2]
  def change
    add_column :player_games, :manual_pts, :integer
  end
end
