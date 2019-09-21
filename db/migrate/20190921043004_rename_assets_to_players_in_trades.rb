class RenameAssetsToPlayersInTrades < ActiveRecord::Migration[5.2]
  def change
    rename_column :trades, :assets_one, :players_one
    rename_column :trades, :assets_two, :players_two
  end
end
