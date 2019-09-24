class PlayerSerializer < ActiveModel::Serializer
  belongs_to :tlfl_team
  attributes :id, :first_name, :last_name, :full_name, :position, :nfl_abbrev, :bye_week, 
  :tlfl_seniority, :fd_id, :available, :ir_fd_id, :ir_week, :esb_id, :cbs_id, :cbs_photo, :nfl_photo
end
