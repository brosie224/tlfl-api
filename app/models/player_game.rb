class PlayerGame < ApplicationRecord
    belongs_to :player


    def self.tlfl_team_pts(tlfl_team_id, season, season_type, week)
        player_games = PlayerGame.where(tlfl_team_id: tlfl_team_id, season: season, season_type: season_type, week: week).sort_position
        all_player_pts = []
        player_games.each do |player_game|
            puts "#{player_game.position} #{player_game.player_name}: #{player_game.tlfl_pts}"
            player_pts ={}
            player_pts[:tlfl_pts] = player_game.tlfl_pts
            all_player_pts << player_pts
        end
        total = all_player_pts.inject(0) {|sum, hash| sum + hash[:tlfl_pts] if hash[:tlfl_pts]}
        puts "Total: #{total}"
    end

    def self.sort_position
        preferred_order = ["QB", "RB", "WR", "TE", "K"]
        self.all.sort_by { |a| preferred_order.index(a[:position]) }
    end

    def tlfl_pts
        pass_pts + rush_pts + rec_pts + return_pts + kick_pts
    end

    def pass_pts
        case pass_yards
        when 0..99 then points = 0
        when 100..149 then points = 1
        when 150..199 then points = 2
        when 200..249 then points = 3
        when 250..299 then points = 4
        when 300..349 then points = 6
        when 350..399 then points = 7
        when 400..449 then points = 9
        when 450..499 then points = 10
        when 500..549 then points = 12
        when 550..599 then points = 13
        when 600..649 then points = 15
        end
        points + (pass_td * 4) + two_pt_pass - pass_int
    end

    def rush_pts
        case rush_yards
        when 0..24 then points = 0
        when 25..49 then points = 1
        when 50..74 then points = 3
        when 75..99 then points = 4
        when 100..124 then points = 6
        when 125..149 then points = 7
        when 150..174 then points = 8
        when 175..199 then points = 9
        when 200..224 then points = 14
        when 225..249 then points = 15
        when 250..274 then points = 16
        when 275..299 then points = 17
        when 300..324 then points = 21
        when 325..349 then points = 22
        when 350..374 then points = 23
        when 375..399 then points = 24
        when 400..424 then points = 28
        end
        points + (rush_td * 6) + (two_pt_rush * 2)
    end

    def rec_pts
        case rec_yards
        when 0..24 then points = 0
        when 25..49 then points = 1
        when 50..74 then points = 3
        when 75..99 then points = 4
        when 100..124 then points = 6
        when 125..149 then points = 7
        when 150..174 then points = 8
        when 175..199 then points = 9
        when 200..224 then points = 14
        when 225..249 then points = 15
        when 250..274 then points = 16
        when 275..299 then points = 17
        when 300..324 then points = 21
        when 325..349 then points = 22
        when 350..374 then points = 23
        when 375..399 then points = 24
        when 400..424 then points = 28
        end
        points + (rec_td * 6) + (two_pt_rec * 2)
    end

    def return_pts
        (punt_ret_td * 6) + (kick_ret_td * 6)
    end

    def kick_pts
        (fgm * 3) + pat
    end

end
