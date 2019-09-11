class TeamDst < ApplicationRecord
    belongs_to :tlfl_team, optional: true

    def full_name
        self.city + " " + self.nickname
    end

end
