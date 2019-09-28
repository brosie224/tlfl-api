class ChangeTeamColumnsToIntegersInTrades < ActiveRecord::Migration[5.2]
  def change
    change_column :trades, :team_one, :integer, using: 'team_one::integer'
    change_column :trades, :team_two, :integer, using: 'team_two::integer'
  end
end
