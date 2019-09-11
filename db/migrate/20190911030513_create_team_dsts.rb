class CreateTeamDsts < ActiveRecord::Migration[5.2]
  def change
    create_table :team_dsts do |t|
      t.string :city
      t.string :nickname
      t.integer :bye_week
      t.string :logo
      t.string :word_mark
      t.integer :tlfl_team_id
      t.integer :fd_id
      t.integer :fd_player_id
      t.integer :nfl_id

      t.timestamps
    end
  end
end
