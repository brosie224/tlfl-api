class RemoveCbsPhotoColumnFromPlayers < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :cbs_photo
  end
end
