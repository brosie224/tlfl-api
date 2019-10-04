class ScheduleGameSerializer < ActiveModel::Serializer
  attributes :id, :pfb_id, :away_team, :home_team, :season, :week, :month, :day, :season_type
end
