class AddProtectionsToTlflTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :tlfl_teams, :protections, :integer, default: 3
  end
end
