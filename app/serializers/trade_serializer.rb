class TradeSerializer < ActiveModel::Serializer
  attributes :id, :season, :week, :team_one_name, :team_one, :team_two_name, :team_two, 
  :players_one_names, :players_one, :players_two_names, :players_two, :dst_one_name, :dst_one, :dst_two_name, :dst_two,
  :picks_one_names, :picks_one, :picks_two_names, :picks_two, :includes_protection_one, :includes_protection_two, 
  :display
end
