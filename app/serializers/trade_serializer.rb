class TradeSerializer < ActiveModel::Serializer
  attributes :id, :season, :week, :team_one, :team_one_name, :team_two, :team_two_name,
  :players_one, :players_one_names, :players_two, :players_two_names, :dst_one, :dst_one_name, :dst_two, :dst_two_name, 
  :picks_one, :picks_one_names, :picks_two, :picks_two_names, :includes_protection_one, :includes_protection_two, 
  :display
end
