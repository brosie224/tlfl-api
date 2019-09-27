class ChangeIrFdIdColumnToIrId < ActiveRecord::Migration[5.2]
  def change
    rename_column :players, :ir_fd_id, :ir_id
  end
end
