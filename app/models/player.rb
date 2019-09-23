class Player < ApplicationRecord
    belongs_to :tlfl_team, optional: true
    validates_uniqueness_of :fd_id

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

end
