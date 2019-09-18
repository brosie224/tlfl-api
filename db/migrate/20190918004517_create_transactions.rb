class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :season
      t.integer :week
      t.string :team_one
      t.string :team_two
      t.text :assets_one, array: true, default: []
      t.text :assets_two, array: true, default: []
      t.boolean :offseason
      t.boolean :includes_protection_one
      t.boolean :includes_protection_two

      t.timestamps
    end
  end
end
