class CreateOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :owners do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.integer :tlfl_team_id

      t.timestamps
    end
  end
end
