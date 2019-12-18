class TlflTeam < ApplicationRecord
    has_many :owners
    has_many :players
    has_one :team_dst
    has_many :draft_picks

    def schedule(season)
        ScheduleGame.where(away_team: abbreviation, season: season).or(ScheduleGame.where(home_team: abbreviation, season: season))
    end

    def week_pts(season, season_type = 1, week)
        player_games = PlayerGame.where(tlfl_team_id: self.id, season: season, season_type: season_type, week: week)
        dst_game = TeamDstGame.find_by(tlfl_team_id: self.id, season: season, season_type: season_type, week: week)
        player_games.sum(&:tlfl_pts) + dst_game.tlfl_pts
    end

    def opp_week_pts(season, season_type = 1, week)
        game = ScheduleGame.where(season: season, week: week, away_team: abbreviation).or(ScheduleGame.where(season: season, week: week, home_team: abbreviation)).take
        if game.home_team == abbreviation
            TlflTeam.find_by(abbreviation: game.away_team).week_pts(season, week)
        else
            TlflTeam.find_by(abbreviation: game.home_team).week_pts(season, week)
        end
    end

    def season_pts(season, season_type = 1)
        player_games = PlayerGame.where(tlfl_team_id: self.id, season: season, season_type: season_type)
        dst_games = TeamDstGame.where(tlfl_team_id: self.id, season: season, season_type: season_type)
        player_games.sum(&:tlfl_pts) + dst_games.sum(&:tlfl_pts)
    end

    def opp_season_pts(season, season_type = 1)
    end
    
    def full_name
        self.city + " " + self.nickname
    end

    def full_division
        self.conference + " " + self.division
    end

end
