class TeamDst < ApplicationRecord
    belongs_to :tlfl_team, optional: true
    validates_uniqueness_of :fd_id

    def week_pts(season, season_type = 1, week)
        TeamDstGame.find_by(team_dst_id: id, season: season, season_type: season_type, week: week).tlfl_pts
    end

    def season_pts(season, season_type = 1)
        TeamDstGame.where(team_dst_id: id, season: season, season_type: season_type).sum(&:tlfl_pts)
    end

    def full_name
        self.city + " " + self.nickname
    end

end
