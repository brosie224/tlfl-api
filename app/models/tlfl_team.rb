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

    def opp_season_pts(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        opp_points = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            opp_points += TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
        end
        opp_points
    end

    def season_wins(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        wins = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
            opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
            wins += 1 if team_game_pts > opp_game_pts 
        end
        wins
    end

    def season_losses(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        losses = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
            opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
            losses += 1 if team_game_pts < opp_game_pts 
        end
        losses
    end

    def season_ties(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        ties = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
            opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
            # if team_game_pts != 0 && opp_game_pts != 0 
            ties += 1 if team_game_pts == opp_game_pts && (team_game_pts != 0 || opp_game_pts != 0)
        end
        ties
    end

    def division_wins(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        wins = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            if TlflTeam.find_by(abbreviation: opp_team).full_division == self.full_division
                team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
                opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
                wins += 1 if team_game_pts > opp_game_pts
            end
        end
        wins
    end

    def division_losses(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        losses = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            if TlflTeam.find_by(abbreviation: opp_team).full_division == self.full_division
                team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
                opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
                losses += 1 if team_game_pts < opp_game_pts
            end
        end
        losses
    end

    def division_ties(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        ties = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            if TlflTeam.find_by(abbreviation: opp_team).full_division == self.full_division
                team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
                opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
                ties += 1 if team_game_pts == opp_game_pts && (team_game_pts != 0 || opp_game_pts != 0)
            end
        end
        ties
    end

    def conference_wins(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        wins = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            if TlflTeam.find_by(abbreviation: opp_team).conference == self.conference
                team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
                opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
                wins += 1 if team_game_pts > opp_game_pts
            end
        end
        wins
    end

    def conference_losses(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        losses = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            if TlflTeam.find_by(abbreviation: opp_team).conference == self.conference
                team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
                opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
                losses += 1 if team_game_pts < opp_game_pts
            end
        end
        losses
    end

    def conference_ties(season, season_type = 1)
        team_games = ScheduleGame.where(season: season, home_team: abbreviation).or(ScheduleGame.where(season: season, away_team: abbreviation))
        ties = 0
        team_games.each do |game|
            game.away_team == abbreviation ? opp_team = game.home_team : opp_team = game.away_team
            if TlflTeam.find_by(abbreviation: opp_team).conference == self.conference
                team_game_pts = TlflTeam.find_by(abbreviation: abbreviation).week_pts(season, game.week)
                opp_game_pts = TlflTeam.find_by(abbreviation: opp_team).week_pts(season, game.week)
                ties += 1 if team_game_pts == opp_game_pts && (team_game_pts != 0 || opp_game_pts != 0)
            end
        end
        ties
    end
    
    def full_name
        self.city + " " + self.nickname
    end

    def full_division
        self.conference + " " + self.division
    end

end
