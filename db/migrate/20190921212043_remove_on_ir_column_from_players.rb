class RemoveOnIrColumnFromPlayers < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :on_ir
  end
end
