class RemoveOffseasonColumnFromTrades < ActiveRecord::Migration[5.2]
  def change
    remove_column :trades, :offseason
  end
end
