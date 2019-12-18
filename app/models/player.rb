class Player < ApplicationRecord
    belongs_to :tlfl_team, optional: true
    has_many :player_games
    validates_uniqueness_of :fd_id

    def week_pts(season, season_type = 1, week)
        PlayerGame.find_by(player_id: id, season: season, season_type: season_type, week: week).tlfl_pts
    end

    def season_pts(season, season_type = 1)
        all_game_pts = []
        player_games = PlayerGame.where(player_id: id, season: season, season_type: season_type)
        player_games.each do |player_game|
            game_pts = {}
            game_pts[:tlfl_pts] = player_game.tlfl_pts
            all_game_pts << game_pts
        end
        all_game_pts.inject(0) {|sum, hash| sum + hash[:tlfl_pts]}
    end

    def full_name
        self.first_name + " " + self.last_name
    end

    def self.sort_position
        preferred_order = ["QB", "RB", "WR", "TE", "K"]
        self.all.sort_by { |a| preferred_order.index(a[:position]) }
    end

    def nfl_photo
        "http://static.nfl.com/static/content/public/static/img/fantasy/transparent/200x200/#{self.esb_id}.png"
    end

    def cbs_photo
        "http://sports.cbsimg.net/images/football/nfl/players/170x170/#{self.cbs_id}.png"
    end

    def replacement_name
        Player.find_by(id: self.ir_id).full_name if self.ir_id
    end

    def replacement_fd_id
        Player.find_by(id: self.ir_id).fd_id if self.ir_id
    end

    def self.missing_esb_data
        self.where(esb_id: nil).where.not(tlfl_team_id: nil)
    end

end
