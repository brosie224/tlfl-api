class TlflTeam < ApplicationRecord
    has_many :owners
    has_many :players
    has_one :team_dst
    has_many :draft_picks

    def team_games(season)
        @team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
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

    def projected_week_pts(season, season_type = 1, week)
    end

    def opp_week_pts(season, season_type = 1, week)
        if game = ScheduleGame.where(season: season, week: week, away_team: abbreviation).or(ScheduleGame.where(season: season, week: week, home_team: abbreviation)).take
            if game.home_team == abbreviation
                TlflTeam.find_by(abbreviation: game.away_team).week_pts(season, week)
            else
                TlflTeam.find_by(abbreviation: game.home_team).week_pts(season, week)
            end
        else
            0
        end
    end

    def season_pts(season, season_type = 1)
        player_games = PlayerGame.where(tlfl_team_id: self.id, season: season, season_type: season_type)
        dst_games = TeamDstGame.where(tlfl_team_id: self.id, season: season, season_type: season_type)
        player_games.sum(&:tlfl_pts) + dst_games.sum(&:tlfl_pts)
    end

    def opp_season_pts(season)
        team_games(season)
        opp_points = 0
        @team_games.each do |game|
            opp_team = game.opp_team(abbreviation)
            opp_points += TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
        end
        opp_points
    end

    def record(season)
        team_games(season)
        @wins = 0
        @losses = 0
        @ties = 0
        @conf_wins = 0
        @conf_losses = 0
        @conf_ties = 0
        @div_wins = 0
        @div_losses = 0
        @div_ties = 0
        @team_games.each do |game|
            opp_team = game.opp_team(abbreviation)
            team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
            opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
            if team_game_pts > opp_game_pts
                @wins += 1
                @conf_wins += 1 if TlflTeam.find_by(abbreviation: opp_team).conference == conference
                @div_wins += 1 if TlflTeam.find_by(abbreviation: opp_team).full_division == full_division
            elsif team_game_pts < opp_game_pts
                @losses += 1
                @conf_losses += 1 if TlflTeam.find_by(abbreviation: opp_team).conference == conference
                @div_losses += 1 if TlflTeam.find_by(abbreviation: opp_team).full_division == full_division
            elsif team_game_pts == opp_game_pts && (team_game_pts != 0 || opp_game_pts != 0)
                @ties += 1
                @conf_ties += 1 if TlflTeam.find_by(abbreviation: opp_team).conference == conference
                @div_ties += 1 if TlflTeam.find_by(abbreviation: opp_team).full_division == full_division
            end
        end
    end

    def season_wins(season)
        record(season)
        @wins
    end

    def season_losses(season)
        record(season)
        @losses
    end

    def season_ties(season)
        record(season)
        @ties
    end

    def division_wins(season)
        record(season)
        @div_wins
    end

    def division_losses(season)
        record(season)
        @div_losses
    end

    def division_ties(season)
        record(season)
        @div_ties
    end

    def conference_wins(season)
        record(season)
        @conf_wins
    end

    def conference_losses(season)
        record(season)
        @conf_losses
    end

    def conference_ties(season)
        record(season)
        @conf_ties
    end
    
    def full_name
        self.city + " " + self.nickname
    end

    def full_division
        self.conference + " " + self.division
    end

end