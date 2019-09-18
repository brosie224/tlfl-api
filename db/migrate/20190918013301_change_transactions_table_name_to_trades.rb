class ChangeTransactionsTableNameToTrades < ActiveRecord::Migration[5.2]
  def change
    rename_table :transactions, :trades
  end
end
