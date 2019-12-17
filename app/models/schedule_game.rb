class ScheduleGame < ApplicationRecord

    def key # YYYYWWHome
        week < 10 ? key_week = "0#{week}" : key_week = week 
        "#{season}#{key_week}#{home_team}"
    end

end
