class AddJerseyToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :jersey, :integer
  end
end
