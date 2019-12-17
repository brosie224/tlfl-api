class Player < ApplicationRecord
    belongs_to :tlfl_team, optional: true
    has_many :player_games
    validates_uniqueness_of :fd_id

    # def week_pts(season, season_type = 1, week)
    # end

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
        if self.ir_id
            Player.find_by(id: self.ir_id).full_name
        end
    end

    def replacement_fd_id
        if self.ir_id
            Player.find_by(id: self.ir_id).fd_id
        end
    end

    def self.missing_esb_data
        self.where(esb_id: nil).where.not(tlfl_team_id: nil)
    end

end
