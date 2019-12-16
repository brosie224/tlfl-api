class DeleteByePtsFromPlayerGame < ActiveRecord::Migration[5.2]
  def change
    remove_column :player_games, :bye_pts
  end
end
