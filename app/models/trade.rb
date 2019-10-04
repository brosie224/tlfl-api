class Trade < ApplicationRecord

    def self.in_season_by_id(season = 2019, team_id)
        self.where(season: season, team_one: team_id).length + self.where(season: season, team_two: team_id).length
    end

    def self.in_season_by_abbrev(season = 2019, team_abbrev)
        team_id = TlflTeam.find_by(abbreviation: team_abbrev).id
        self.where(season: season, team_one: team_id).length + self.where(season: season, team_two: team_id).length
    end

    def display
        assets_one, assets_two = [], []
        
        self.players_one_names.map {|player| assets_one << player} if self.players_one.length > 0
        self.players_two_names.map {|player| assets_two << player} if self.players_two.length > 0
        assets_one << self.dst_one_name + " Defense" if self.dst_one
        assets_two << self.dst_two_name + " Defense" if self.dst_two
        self.picks_one_names.map {|pick| assets_one << pick} if self.picks_one.length > 0
        self.picks_two_names.map {|pick| assets_two << pick} if self.picks_two.length > 0
        assets_one << "Protection Spot" if self.includes_protection_one
        assets_two << "Protection Spot" if self.includes_protection_two


        ["#{self.team_one_name.upcase} #{"(#{self.team_one_total})" if self.week != 0} receive: #{assets_two.join(", ")}",
        "#{self.team_two_name.upcase} #{"(#{self.team_two_total})" if self.week != 0} receive: #{assets_one.join(", ")}"]
    end

    def team_one_name
        team = TlflTeam.find_by(id: self.team_one)
        team.nickname
    end

    def team_two_name
        team = TlflTeam.find_by(id: self.team_two)
        team.nickname
    end

    def players_one_names
        self.players_one.map do |player_id|
            p = Player.find_by(id: player_id)
            "#{p.position} #{p.full_name}" 
        end
    end

    def players_two_names
        self.players_two.map do |player_id|
            p = Player.find_by(id: player_id)
            "#{p.position} #{p.full_name}" 
        end
    end

    def dst_one_name
        if dst_one
            dst = TeamDst.find_by(id: self.dst_one)
            dst.full_name
        end
    end

    def dst_two_name
        if dst_two
            dst = TeamDst.find_by(id: self.dst_two)
            dst.full_name
        end
    end

    def picks_one_names
        self.picks_one.map do |pick_id|
            p = DraftPick.find_by(id: pick_id)
            p.full
        end
    end

    def picks_two_names
        self.picks_two.map do |pick_id|
            p = DraftPick.find_by(id: pick_id)
            p.full
        end
    end

end
