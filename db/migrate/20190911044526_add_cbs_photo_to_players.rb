class AddCbsPhotoToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :cbs_photo, :string
  end
end
