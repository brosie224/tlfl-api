class TeamDst < ApplicationRecord
    belongs_to :tlfl_team, optional: true
    validates_uniqueness_of :fd_id

    # def week_pts(season, season_type = 1, week)
    # end

    # def season_pts(season, season_type = 1)
    # end

    def full_name
        self.city + " " + self.nickname
    end

end
