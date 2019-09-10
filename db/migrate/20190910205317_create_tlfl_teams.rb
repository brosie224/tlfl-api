class CreateTlflTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :tlfl_teams do |t|
      t.string :city
      t.string :nickname
      t.string :conference
      t.string :division
      t.integer :bye_week
      t.string :nfl_team
      t.integer :fd_id
      t.integer :nfl_id
      t.string :logo
      t.string :word_mark
      t.string :primary_color
      t.string :secondary_color
      t.string :tertiary_color
      t.string :quaternary_color

      t.timestamps
    end
  end
end
