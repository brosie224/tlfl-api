class ProjectedTeamDstGame < ApplicationRecord
    belongs_to :team_dst

    def tlfl_pts
            points_allowed == 0? shutout = 5 : shutout = 0
            ((touchdowns * 6) + sacks + fumbles_recovered + interceptions + (safeties * 2) + (two_pt_ret * 2) + shutout).round
    end
end
