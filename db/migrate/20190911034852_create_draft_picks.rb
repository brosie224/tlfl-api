class CreateDraftPicks < ActiveRecord::Migration[5.2]
  def change
    create_table :draft_picks do |t|
      t.string :team
      t.integer :year
      t.integer :round
      t.integer :tlfl_team_id

      t.timestamps
    end
  end
end
