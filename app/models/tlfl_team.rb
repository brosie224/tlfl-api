class TlflTeam < ApplicationRecord
    has_many :owners
    has_many :players
    has_one :team_dst
    has_many :draft_picks

    def full_name
        self.city + " " + self.nickname
    end

    def full_division
        self.conference + " " + self.division
    end

    def week_pts(season, season_type = 1, week)
        player_games = PlayerGame.where(tlfl_team_id: self.id, season: season, season_type: season_type, week: week).sort_position
        all_player_pts = []
        player_games.each do |player_game|
            puts "#{player_game.position} #{player_game.player_name}: #{player_game.tlfl_pts}"
            player_pts = {}
            player_pts[:tlfl_pts] = player_game.tlfl_pts
            all_player_pts << player_pts
        end
        total = all_player_pts.inject(0) {|sum, hash| sum + hash[:tlfl_pts]}
        puts "Total: #{total}"
    end

end
