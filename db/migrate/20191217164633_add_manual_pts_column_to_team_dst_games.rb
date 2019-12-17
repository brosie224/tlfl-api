class AddManualPtsColumnToTeamDstGames < ActiveRecord::Migration[5.2]
  def change
    add_column :team_dst_games, :manual_pts, :integer
  end
end
