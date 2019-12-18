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
        if player_games && dst_game
            player_games.sum(&:tlfl_pts) + dst_game.tlfl_pts
        elsif player_games # if dst hasn't played yet
            player_games.sum(&:tlfl_pts)
        elsif dst_game # if no player has played yet
            dst_game.tlfl_pts
        else # if no player or dst has played yet
            0
        end
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
        away_games = ScheduleGame.where(season: season, away_team: abbreviation)
        home_games = ScheduleGame.where(season: season, home_team: abbreviation)
        opp_game_pts = []
        away_games.each do |game|
            opp_game_pts << TlflTeam.find_by(abbreviation: game.home_team).week_pts(season, game.week)
        end
        home_games.each do |game|
            opp_game_pts << TlflTeam.find_by(abbreviation: game.away_team).week_pts(season, game.week)
        end
        opp_game_pts.inject(0){|sum, pts| sum + pts}
    end

    def wins
    end

    def losses
    end
    
    def full_name
        self.city + " " + self.nickname
    end

    def full_division
        self.conference + " " + self.division
    end

end
