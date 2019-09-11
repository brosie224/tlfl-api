class AddColumnsToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :position, :string
    add_column :players, :nfl_team, :string
    add_column :players, :on_ir, :boolean, default: false
    add_column :players, :ir_fd_id, :integer
    add_column :players, :tlfl_seniority, :integer
    add_column :players, :bye_week, :integer
    add_column :players, :tlfl_team_id, :integer
    add_column :players, :fd_id, :integer
    add_column :players, :fd_nfl_id, :integer
    add_column :players, :cbs_id, :integer
    add_column :players, :nfl_id, :integer
    add_column :players, :esb_id, :integer
  end
end
