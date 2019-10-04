class AddTeamTotalTradesToTrades < ActiveRecord::Migration[5.2]
  def change
    add_column :trades, :team_one_total, :integer
    add_column :trades, :team_two_total, :integer
  end
end
