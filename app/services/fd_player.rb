require 'open-uri'
class FdPlayer < TimeFrame

# -- WEEKLY STATS -- 

    def get_player_games
        stats_resp = Faraday.get "https://api.fantasydata.net/api/nfl/fantasy/json/PlayerGameStatsByWeek/#{@current_api_season}/#{@current_week}" do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        @stats_json = JSON.parse(stats_resp.body)
    end

    def create_qb_k_games
        current_timeframe
        get_player_games
        tlfl_players = Player.where.not(tlfl_team_id: nil, bye_week: @current_week)
        tlfl_qb_k = tlfl_players.where(position: "QB").or(tlfl_players.where(position: "K"))
        tlfl_qb_k.each do |tlfl_player|
            if player_stats = @stats_json.select {|fd_player| fd_player["Team"] == tlfl_player.nfl_abbrev && fd_player["Position"] == tlfl_player.position && fd_player["Played"] == 1}
                byebug
                pass_comp = player_stats.inject(0) {|sum, hash| sum + hash["PassingCompletions"]}.round
                pass_att = player_stats.inject(0) {|sum, hash| sum + hash["PassingAttempts"]}.round
                pass_yards = player_stats.inject(0) {|sum, hash| sum + hash["PassingYards"]}.round
                pass_td = player_stats.inject(0) {|sum, hash| sum + hash["PassingTouchdowns"]}.round
                pass_int = player_stats.inject(0) {|sum, hash| sum + hash["PassingInterceptions"]}.round
                rushes = player_stats.inject(0) {|sum, hash| sum + hash["RushingAttempts"]}.round
                rush_yards = player_stats.inject(0) {|sum, hash| sum + hash["RushingYards"]}.round
                rush_td = player_stats.inject(0) {|sum, hash| sum + hash["RushingTouchdowns"]}.round
                receptions = player_stats.inject(0) {|sum, hash| sum + hash["Receptions"]}.round
                rec_yards = player_stats.inject(0) {|sum, hash| sum + hash["ReceivingYards"]}.round
                rec_td = player_stats.inject(0) {|sum, hash| sum + hash["ReceivingTouchdowns"]}.round
                punt_ret_td = player_stats.inject(0) {|sum, hash| sum + hash["PuntReturnTouchdowns"]}.round
                kick_ret_td = player_stats.inject(0) {|sum, hash| sum + hash["KickReturnTouchdowns"]}.round
                two_pt_pass = player_stats.inject(0) {|sum, hash| sum + hash["TwoPointConversionPasses"]}.round
                two_pt_rush = player_stats.inject(0) {|sum, hash| sum + hash["TwoPointConversionRuns"]}.round
                two_pt_rec = player_stats.inject(0) {|sum, hash| sum + hash["TwoPointConversionReceptions"]}.round
                fgm = player_stats.inject(0) {|sum, hash| sum + hash["FieldGoalsMade"]}.round
                fga = player_stats.inject(0) {|sum, hash| sum + hash["FieldGoalsAttempted"]}.round
                pat = player_stats.inject(0) {|sum, hash| sum + hash["ExtraPointsMade"]}.round
                if game = PlayerGame.find_by(player_id: tlfl_player.id, season: @current_season, season_type: @current_season_type, week: @current_week)
                    game.update(
                        pass_comp: pass_comp,
                        pass_att: pass_att,
                        pass_yards: pass_yards,
                        pass_td: pass_td,
                        pass_int: pass_int,
                        rushes: rushes,
                        rush_yards: rush_yards,
                        rush_td: rush_td,
                        receptions: receptions,
                        rec_yards: rec_yards,
                        rec_td: rec_td,
                        punt_ret_td: punt_ret_td,
                        kick_ret_td: kick_ret_td,
                        two_pt_pass: two_pt_pass,
                        two_pt_rush: two_pt_rush,
                        two_pt_rec: two_pt_rec,
                        fgm: fgm,
                        fga: fga,
                        pat: pat
                    )
                else
                    PlayerGame.create(
                        player_id: tlfl_player.id,
                        player_name: tlfl_player.full_name,
                        position: tlfl_player.position,
                        tlfl_team_id: tlfl_player.tlfl_team_id,
                        season: @current_season,
                        season_type: @current_season_type,
                        week: @current_week,
                        nfl_team: tlfl_player.nfl_abbrev,
                        pass_comp: pass_comp,
                        pass_att: pass_att,
                        pass_yards: pass_yards,
                        pass_td: pass_td,
                        pass_int: pass_int,
                        rushes: rushes,
                        rush_yards: rush_yards,
                        rush_td: rush_td,
                        receptions: receptions,
                        rec_yards: rec_yards,
                        rec_td: rec_td,
                        punt_ret_td: punt_ret_td,
                        kick_ret_td: kick_ret_td,
                        two_pt_pass: two_pt_pass,
                        two_pt_rush: two_pt_rush,
                        two_pt_rec: two_pt_rec,
                        fgm: fgm,
                        fga: fga,
                        pat: pat
                    )
                end
            else
                # If player doesn't appear on FD's API (stats default to 0)
                PlayerGame.create(
                    player_id: tlfl_player.id,
                    player_name: tlfl_player.full_name,
                    position: tlfl_player.position,
                    tlfl_team_id: tlfl_player.tlfl_team_id,
                    season: @current_season,
                    season_type: @current_season_type,
                    week: @current_week,
                    nfl_team: tlfl_player.nfl_abbrev
                )
            end
        end
    end

    def create_rb_wr_te_games
        # current_timeframe
        # get_player_games
        week_injury_status
        @tlfl_skill_players.each do |tlfl_player|
            tlfl_player.ir_id ? fd_id = Player.find_by(id: tlfl_player.ir_id).fd_id : fd_id = tlfl_player.fd_id
            player_game = PlayerGame.find_by(player_id: tlfl_player.id, season: @current_season, season_type: @current_season_type, week: @current_week)
            if player_stats = @stats_json.find {|fd_player| fd_player["PlayerID"] == fd_id}
                if player_game
                    player_game.update(
                        pass_comp: player_stats["PassingCompletions"],
                        pass_att: player_stats["PassingAttempts"],
                        pass_yards: player_stats["PassingYards"],
                        pass_td: player_stats["PassingTouchdowns"],
                        pass_int: player_stats["PassingInterceptions"],
                        rushes: player_stats["RushingAttempts"],
                        rush_yards: player_stats["RushingYards"],
                        rush_td: player_stats["RushingTouchdowns"],
                        receptions: player_stats["Receptions"],
                        rec_yards: player_stats["ReceivingYards"],
                        rec_td: player_stats["ReceivingTouchdowns"],
                        punt_ret_td: player_stats["PuntReturnTouchdowns"],
                        kick_ret_td: player_stats["KickReturnTouchdowns"],
                        two_pt_pass: player_stats["TwoPointConversionPasses"],
                        two_pt_rush: player_stats["TwoPointConversionRuns"],
                        two_pt_rec: player_stats["TwoPointConversionReceptions"],
                        fgm: player_stats["FieldGoalsMade"],
                        fga: player_stats["FieldGoalsAttempted"],
                        pat: player_stats["ExtraPointsMade"]
                    )
                else
                    PlayerGame.create(
                        player_id: tlfl_player.id,
                        player_name: tlfl_player.full_name,
                        position: tlfl_player.position,
                        tlfl_team_id: tlfl_player.tlfl_team_id,
                        season: @current_season,
                        season_type: @current_season_type,
                        week: @current_week,
                        nfl_team: tlfl_player.nfl_abbrev,
                        pass_comp: player_stats["PassingCompletions"],
                        pass_att: player_stats["PassingAttempts"],
                        pass_yards: player_stats["PassingYards"],
                        pass_td: player_stats["PassingTouchdowns"],
                        pass_int: player_stats["PassingInterceptions"],
                        rushes: player_stats["RushingAttempts"],
                        rush_yards: player_stats["RushingYards"],
                        rush_td: player_stats["RushingTouchdowns"],
                        receptions: player_stats["Receptions"],
                        rec_yards: player_stats["ReceivingYards"],
                        rec_td: player_stats["ReceivingTouchdowns"],
                        punt_ret_td: player_stats["PuntReturnTouchdowns"],
                        kick_ret_td: player_stats["KickReturnTouchdowns"],
                        two_pt_pass: player_stats["TwoPointConversionPasses"],
                        two_pt_rush: player_stats["TwoPointConversionRuns"],
                        two_pt_rec: player_stats["TwoPointConversionReceptions"],
                        fgm: player_stats["FieldGoalsMade"],
                        fga: player_stats["FieldGoalsAttempted"],
                        pat: player_stats["ExtraPointsMade"]
                    )
                end
            elsif !player_game
                # If player doesn't appear on FD's API and game wasn't previously created due to inactive (stats default to 0)
                PlayerGame.create(
                    player_id: tlfl_player.id,
                    player_name: tlfl_player.full_name,
                    position: tlfl_player.position,
                    tlfl_team_id: tlfl_player.tlfl_team_id,
                    season: @current_season,
                    season_type: @current_season_type,
                    week: @current_week,
                    nfl_team: tlfl_player.nfl_abbrev
                )
            end
        end
    end

    def create_all_player_games
        current_timeframe
        if @current_season_type == 1
            get_player_games
            create_qb_k_games
            create_rb_wr_te_games
        end
    end

    def week_injury_status
        # current_timeframe
        # Inactives
        doc = Nokogiri::HTML(open("http://www.nfl.com/inactives?week=#{@current_week}"))
        text = doc.css("script").text
        matches = text.scan(/status: "(\S*)".+?esbId: ?"(\S*)"/)
        inactive_hash = {}
        matches.each do |status, esb|
            if status == "Inactive"
                inactive_hash[esb] = status
            end
        end
        # Injuries
        doc = Nokogiri::HTML(open("http://www.nfl.com/injuries?week=#{@current_week}"))
        text = doc.css("script").text
        matches = text.scan(/gameStatus: "(\S*)".+?esbId: ?"(\S*)"/)
        injury_status_hash = {}
        matches.each do |status, esb|
            if status != "--"
                injury_status_hash[esb] = status
            end
        end
        # Create PlayerGame if TLFL player is inactive and injured
        tlfl_players = Player.where.not(tlfl_team_id: nil, bye_week: @current_week)
        @tlfl_skill_players = tlfl_players.where(position: "RB").or(tlfl_players.where(position: "WR")).or(tlfl_players.where(position: "TE"))
        @tlfl_skill_players.each do |tlfl_player|
            tlfl_player.ir_id ? esb = Player.find_by(id: tlfl_player.ir_id).esb_id : esb = tlfl_player.esb_id
            if inactive_hash[esb] && injury_status_hash[esb]
                PlayerGame.create(
                    player_id: tlfl_player.id,
                    player_name: tlfl_player.full_name,
                    position: tlfl_player.position,
                    tlfl_team_id: tlfl_player.tlfl_team_id,
                    season: @current_season,
                    season_type: @current_season_type,
                    week: @current_week,
                    nfl_team: tlfl_player.nfl_abbrev,
                    needs_replacement: true
                )
            end
        end
    end

    # -- IN-SEASON METHODS --

    def get_player_data
        players_resp = Faraday.get 'https://api.fantasydata.net/api/nfl/fantasy/json/Players' do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        @players_json = JSON.parse(players_resp.body)
        actives = @players_json.select { |player| player["Status"] == "Active" }
        @active_players = actives.select { |player| %w(QB RB FB WR TE K).include? player["Position"] }
    end

    def create_new_players
        get_player_data
        @active_players = @active_players.sort_by { |player| player["LastName"] }
        @active_players.each do |fd_player|
            Player.find_or_create_by(fd_id: fd_player["PlayerID"]) do |new_player|
                new_player.first_name = fd_player["FirstName"]
                new_player.last_name = fd_player["LastName"]
                new_player.position = fd_player["Position"]
                new_player.position = "RB" if new_player.position == "FB"
                new_player.nfl_abbrev = fd_player["Team"]
                new_player.bye_week = fd_player["ByeWeek"]
                new_player.jersey = fd_player["Number"]
            end
        end
    end

    # Creates and Deletes players to show only active NFL players (Won't delete players on TLFL team)
    def update_available_players
        create_new_players
        available_players = Player.where(available: true)
        available_players.each do |tlfl_player|
            if !@active_players.find {|fd_player| fd_player["PlayerID"] == tlfl_player.fd_id} 
                tlfl_player.destroy
            end
        end
    end

    # Updates player NFL teams (or if NFL team city/name changes)
    def update_player_nfl_data
        get_player_data
        free_agents = Player.where(tlfl_team_id: nil)
        players_on_team = Player.where.not(tlfl_team_id: nil)
        players_on_team.each do |tlfl_player|
            # Doesn't change a current TLFL player's team if he isn't on an NFL team anymore
            if fd_player = @players_json.find {|fd_player| fd_player["PlayerID"] == tlfl_player.fd_id && fd_player["Team"] != tlfl_player.nfl_abbrev && fd_player["Team"]} 
                tlfl_player.update(nfl_abbrev: fd_player["Team"], bye_week: fd_player["ByeWeek"], jersey: fd_player["Number"])
            end
        end
        free_agents.each do |tlfl_player|
            if fd_player = @players_json.find {|fd_player| fd_player["PlayerID"] == tlfl_player.fd_id && fd_player["Team"] != tlfl_player.nfl_abbrev} 
                tlfl_player.update(nfl_abbrev: fd_player["Team"], bye_week: fd_player["ByeWeek"], jersey: fd_player["Number"])
            end
        end
    end

    def add_cbs_data_to_players
        # Double check link works
        cbs_resp = Faraday.get "http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=football&response_format=json"
        cbs_json = JSON.parse(cbs_resp.body)
        players = Player.all
        cbs_json["body"]["players"].each do |cbs_player|
            players.each do |player|
                if player.cbs_id == nil && player.nfl_abbrev == "JAX" && cbs_player["pro_team"] == "JAC" && player.position == cbs_player["position"] && player.jersey == cbs_player["jersey"].to_i
                    player.update(cbs_id: cbs_player["id"].to_i, esb_id: cbs_player["elias_id"])
                end
                if player.cbs_id == nil && player.nfl_abbrev == cbs_player["pro_team"] && player.position == cbs_player["position"] && player.jersey == cbs_player["jersey"].to_i
                    player.update(cbs_id: cbs_player["id"].to_i, esb_id: cbs_player["elias_id"])
                end
            end
        end
    end

    # -- OFFSEASON METHODS --
    

    # -- INITIAL CREATE METHODS --

end
