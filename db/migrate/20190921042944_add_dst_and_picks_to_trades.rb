class AddDstAndPicksToTrades < ActiveRecord::Migration[5.2]
  def change
    add_column :trades, :dst_one, :integer
    add_column :trades, :dst_two, :integer
    add_column :trades, :picks_one, :text, array: true, default: []
    add_column :trades, :picks_two, :text, array: true, default: []
  end
end
