class PlayerSerializer < ActiveModel::Serializer
  belongs_to :tlfl_team
  attributes :id, :first_name, :last_name, :full_name, :position, :nfl_abbrev, :on_ir, :ir_fd_id,
  :tlfl_seniority, :bye_week, :fd_id, :esb_id, :cbs_id, :cbs_photo
end
