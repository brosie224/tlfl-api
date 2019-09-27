class CreateReserves < ActiveRecord::Migration[5.2]
  def change
    create_table :reserves do |t|
      t.integer :week
      t.string :named_player
      t.string :replacement_player
      t.string :type

      t.timestamps
    end
  end
end
