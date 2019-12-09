class CreatePlayerGames < ActiveRecord::Migration[5.2]
  def change
    create_table :player_games do |t|
      t.integer :season
      t.integer :season_type
      t.integer :week
      t.string :player_name
      t.string :nfl_team
      t.string :tlfl_team
      t.string :position
      t.string :injury_status
      t.boolean :active
      t.boolean :needs_replacement
      t.integer :tlfl_pts
      t.integer :pass_comp
      t.integer :pass_att
      t.integer :pass_yards
      t.integer :pass_td
      t.integer :pass_int
      t.integer :rushes
      t.integer :rush_yards
      t.integer :rush_td
      t.integer :receptions
      t.integer :rec_yards
      t.integer :rec_td
      t.integer :punt_ret_td
      t.integer :kick_ret_td
      t.integer :two_pt_pass
      t.integer :two_pt_rush
      t.integer :two_pt_rec
      t.integer :fgm
      t.integer :fga
      t.integer :pat

      t.timestamps
    end
  end
end
