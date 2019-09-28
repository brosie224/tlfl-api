class ChangeColumnsToIntegersInTrades < ActiveRecord::Migration[5.2]
  def change
    change_column :trades, :dst_one, :integer, using: 'dst_one::integer'
    change_column :trades, :dst_two, :integer, using: 'dst_two::integer'
  end
end
