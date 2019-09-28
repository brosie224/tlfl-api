class ChangeColumnNameTlflSeniorityInPlayers < ActiveRecord::Migration[5.2]
  def change
    rename_column :players, :tlfl_seniority, :seniority
  end
end
