class TeamDstGame < ApplicationRecord
    belongs_to :team_dst

    def tlfl_pts
        
        self.points_allowed == 0? shutout = 5 : shutout = 0
        (self.touchdowns * 6) + self.sacks + self.fumbles_recovered + self.interceptions + (self.safeties * 2) + (self.two_pt_ret * 2) + shutout
    end
end
