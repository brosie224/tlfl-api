class CreateProjectedTeamDstGames < ActiveRecord::Migration[5.2]
  def change
    create_table :projected_team_dst_games do |t|
      t.integer :team_dst_id
      t.string :team_name
      t.integer :tlfl_team_id
      t.integer :season
      t.integer :season_type
      t.integer :week
      t.string :nfl_abbrev
      t.integer :points_allowed, default: 99
      t.integer :touchdowns, default: 0
      t.integer :sacks, default: 0
      t.integer :fumbles_recovered, default: 0
      t.integer :interceptions, default: 0
      t.integer :safeties, default: 0
      t.integer :two_pt_ret, default: 0

      t.timestamps
    end
  end
end
