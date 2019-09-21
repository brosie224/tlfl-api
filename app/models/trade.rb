class Trade < ApplicationRecord

    def display
        assets_one, assets_two = [], []
        
        self.players_one.map {|player| assets_one << player} if self.players_one.length > 0
        self.players_two.map {|player| assets_two << player} if self.players_two.length > 0
        assets_one << self.dst_one + " Defense" if self.dst_one
        assets_two << self.dst_two + " Defense" if self.dst_two
        self.picks_one.map {|pick| assets_one << pick} if self.picks_one.length > 0
        self.picks_two.map {|pick| assets_two << pick} if self.picks_two.length > 0
        assets_one << "Protection Spot" if self.includes_protection_one
        assets_two << "Protection Spot" if self.includes_protection_two


        ["#{self.team_one} receive: #{assets_two.join(", ")}",
        "#{self.team_two} receive: #{assets_one.join(", ")}"]
    end

end
