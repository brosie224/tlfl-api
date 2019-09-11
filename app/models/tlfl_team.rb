class TlflTeam < ApplicationRecord
    has_many :owners
    has_many :players
    has_one :team_dst
    has_many :draft_picks

    def full_name
        self.city + " " + self.nickname
    end

    def full_division
        self.conference + " " + self.division
    end

end
