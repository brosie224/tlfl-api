class AddIrWeekColumnToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :ir_week, :integer
  end
end
