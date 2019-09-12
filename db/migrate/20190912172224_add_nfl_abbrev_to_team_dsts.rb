class AddNflAbbrevToTeamDsts < ActiveRecord::Migration[5.2]
  def change
    add_column :team_dsts, :nfl_abbrev, :string
  end
end
