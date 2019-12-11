class AddByePtsColumnToPlayerGames < ActiveRecord::Migration[5.2]
  def change
    add_column :player_games, :bye_pts, :integer
  end
end
