class ReserveSerializer < ActiveModel::Serializer
  attributes :id, :season, :week, :tlfl_team, :tlfl_team_id,
  :named_player_name, :named_player, :replacement_player_name, :replacement_player,  
  :category, :display
end
