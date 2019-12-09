class PlayerGame < ApplicationRecord
    belongs_to :player

    def tlfl_pts
        # add all methods together
    end

    def pass_pts
        # yards, td, int, 2pt
        # points = 0
        case self.pass_yards
        when 0..99 then points = 0
        when 100..149 then points = 1
        when 150..199 then points = 2
        when 200..249 then points = 3
        when 250..299 then points = 4
        when 300..349 then points = 6
        when 350..399 then points = 7
        when 400..449 then points = 9
        when 450..499 then points = 10
        when 500..549 then points = 12
        when 550..599 then points = 13
        when 600..649 then points = 15
        end
        points + (self.pass_td*4) + self.two_pt_pass - self.pass_int
    end

    def rush_pts
    end

    def rec_pts
    end

    def return_pts
    end

    def kick_pts
    end

end
