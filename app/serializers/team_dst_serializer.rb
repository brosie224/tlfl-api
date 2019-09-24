class TeamDstSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :nfl_abbrev, :logo, :word_mark, :tlfl_team_id
end
