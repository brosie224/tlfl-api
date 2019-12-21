class PlayerGame < ApplicationRecord
    include PlayerPts
    belongs_to :player

    def tlfl_pts
        manual_pts ? manual_pts : pass_pts + rush_pts + rec_pts + return_pts + kick_pts
    end

end
