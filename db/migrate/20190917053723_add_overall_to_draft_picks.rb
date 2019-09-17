class AddOverallToDraftPicks < ActiveRecord::Migration[5.2]
  def change
    add_column :draft_picks, :overall, :integer
  end
end
