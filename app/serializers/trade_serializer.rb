class TradeSerializer < ActiveModel::Serializer
  attributes :id, :season, :week, :team_one, :team_two, :players_one, :players_two,
  :dst_one, :dst_two, :picks_one, :picks_two, :includes_protection_one, :includes_protection_two, :display
end
