class DraftPickSerializer < ActiveModel::Serializer
  attributes :id, :team, :year, :round
end