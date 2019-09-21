class ChangeDstInTradesToString < ActiveRecord::Migration[5.2]
  def change
    change_column :trades, :dst_one, :string
    change_column :trades, :dst_two, :string
  end
end
