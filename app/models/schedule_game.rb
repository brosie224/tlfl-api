class ScheduleGame < ApplicationRecord

    def key # YYYYWWHome
        week < 10 ? key_week = "0#{week}" : key_week = week 
        "#{season}#{key_week}#{home_team}"
    end

    def self.team_schedule(season, team_abbrev)
        ScheduleGame.where(away_team: team_abbrev, season: season).or(ScheduleGame.where(home_team: team_abbrev, season: season))
    end

    def home_id
        TlflTeam.find_by(abbreviation: home_team).id
    end

    def away_id
        TlflTeam.find_by(abbreviation: away_team).id
    end

    def home_players
        TlflTeam.find_by(abbreviation: home_team).players
    end

    def away_players
        TlflTeam.find_by(abbreviation: away_team).players
    end
    
    def opp_team(team)
        away_team == team ? home_team : away_team
    end
end
