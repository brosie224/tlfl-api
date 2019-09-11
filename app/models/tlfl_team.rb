class TlflTeam < ApplicationRecord
    has_many :owners
    has_many :players
    has_one :team_dst

    def full_name
        self.city + " " + self.nickname
    end

    def full_division
        self.conference + " " + self.division
    end

end
