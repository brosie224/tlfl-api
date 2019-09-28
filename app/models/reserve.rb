class Reserve < ApplicationRecord

    def display
        if self.category == "new"
            "#{self.tlfl_team.upcase} reserve #{self.reserved_player_name}, name #{self.replacement_player_name}."
        elsif self.category == "activate"
            "#{self.tlfl_team.upcase} activate #{self.reserved_player_name}."
        # else # change replacement
        end
    end

    def reserved_player_name
        player = Player.find_by(id: self.named_player)
        "#{player.position} #{player.full_name}"
    end

    def replacement_player_name
        player = Player.find_by(id: self.replacement_player)
        "#{player.position} #{player.full_name}"
    end

    def tlfl_team
        player = Player.find_by(id: self.named_player)
        player.tlfl_team.nickname
    end

end
