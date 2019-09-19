class DraftPickSerializer < ActiveModel::Serializer
  attributes :id, :team, :year, :round, :overall, :full
end
