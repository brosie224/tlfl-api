class CreateTeamDstGames < ActiveRecord::Migration[5.2]
  def change
    create_table :team_dst_games do |t|
      t.integer :team_dst_id
      t.string :team_name
      t.integer :tlfl_team_id
      t.integer :season
      t.integer :season_type
      t.integer :week
      t.string :nfl_abbrev
      t.integer :points_allowed
      t.integer :touchdowns
      t.integer :sacks
      t.integer :fumbles_recovered
      t.integer :interceptions
      t.integer :safeties
      t.integer :two_pt_ret

      t.timestamps
    end
  end
end
