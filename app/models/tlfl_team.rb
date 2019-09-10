class TlflTeam < ApplicationRecord
    has_many :owners

    def full_name
        self.city + " " + self.nickname
    end

    def full_division
        self.conference + " " + self.division
    end
    
end
