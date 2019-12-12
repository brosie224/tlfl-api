class DeleteInjuryAndActiveColumnsFromPlayerGame < ActiveRecord::Migration[5.2]
  def change
    remove_column :player_games, :injury_status
    remove_column :player_games, :active
  end
end
