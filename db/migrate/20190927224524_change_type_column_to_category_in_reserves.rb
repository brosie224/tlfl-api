class ChangeTypeColumnToCategoryInReserves < ActiveRecord::Migration[5.2]
  def change
    rename_column :reserves, :type, :category
  end
end
