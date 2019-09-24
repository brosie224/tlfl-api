class AddColumnAvailableToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :available, :boolean, default: true
  end
end
