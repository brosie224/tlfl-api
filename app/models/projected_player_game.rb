class ProjectedPlayerGame < ApplicationRecord
    include PlayerPts
    belongs_to :player

    def tlfl_pts
        (pass_pts + rush_pts + rec_pts + return_pts + kick_pts).round
    end

end
