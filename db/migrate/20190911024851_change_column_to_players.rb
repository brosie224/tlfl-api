class ChangeColumnToPlayers < ActiveRecord::Migration[5.2]
  def change
    change_column :players, :tlfl_seniority, :integer, default: 1
  end
end
