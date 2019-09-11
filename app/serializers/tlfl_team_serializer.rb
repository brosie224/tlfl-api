class TlflTeamSerializer < ActiveModel::Serializer
  has_many :owners
  has_many :players
  has_one :team_dst
  has_many :draft_picks

  attributes :id, :full_name, :abbreviation, :conference, :division, :full_division, :logo,
  :word_mark, :primary_color, :secondary_color, :tertiary_color, :quaternary_color
end
