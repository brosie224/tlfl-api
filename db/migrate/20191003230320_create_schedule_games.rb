class CreateScheduleGames < ActiveRecord::Migration[5.2]
  def change
    create_table :schedule_games do |t|
      t.integer :pfb_id
      t.string :home_team
      t.string :away_team
      t.integer :season
      t.integer :week
      t.integer :month
      t.integer :day
      t.string :season_type

      t.timestamps
    end
  end
end
