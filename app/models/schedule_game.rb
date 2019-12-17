class ScheduleGame < ApplicationRecord

    def key # YYYYWWHome
        week < 10 ? key_week = "0#{week}" : key_week = week 
        "#{season}#{key_week}#{home_team}"
    end

    def home_id
        TlflTeam.find_by(abbreviation: home_team).id
    end

    def away_id
        TlflTeam.find_by(abbreviation: away_team).id
    end

end
