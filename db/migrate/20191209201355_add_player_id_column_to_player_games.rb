class AddPlayerIdColumnToPlayerGames < ActiveRecord::Migration[5.2]
  def change
    add_column :player_games, :player_id, :integer
  end
end
