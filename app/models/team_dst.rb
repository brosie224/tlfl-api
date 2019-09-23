class TeamDst < ApplicationRecord
    belongs_to :tlfl_team, optional: true
    validates_uniqueness_of :fd_id

    def full_name
        self.city + " " + self.nickname
    end

end
