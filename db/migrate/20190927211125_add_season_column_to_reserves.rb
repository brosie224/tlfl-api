class AddSeasonColumnToReserves < ActiveRecord::Migration[5.2]
  def change
    add_column :reserves, :season, :integer
  end
end
