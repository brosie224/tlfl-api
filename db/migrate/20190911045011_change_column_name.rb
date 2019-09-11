class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :tlfl_teams, :nfl_team, :abbreviation
    rename_column :players, :nfl_team, :nfl_abbrev
  end
end
