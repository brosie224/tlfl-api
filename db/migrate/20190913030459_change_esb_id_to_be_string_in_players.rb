class ChangeEsbIdToBeStringInPlayers < ActiveRecord::Migration[5.2]
  def change
    change_column :players, :esb_id, :string
  end
end
