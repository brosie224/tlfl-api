class ProjectedPlayerGame < ApplicationRecord
    include PlayerPts

    def self.sort_position
        preferred_order = ["QB", "RB", "WR", "TE", "K"]
        self.all.sort_by { |a| preferred_order.index(a[:position]) }
    end

    def tlfl_pts
        pass_pts + rush_pts + rec_pts + return_pts + kick_pts
    end

end
