class TlflTeamSerializer < ActiveModel::Serializer
  has_many :owners
  has_many :players

  attributes :id, :full_name, :conference, :division, :full_division, :logo,
  :word_mark, :primary_color, :secondary_color, :tertiary_color, :quaternary_color
end
