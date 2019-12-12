require 'open-uri'

class FdPlayer

# -- IN-SEASON METHODS -- 

    def current_timeframe
        time_resp = Faraday.get 'https://api.fantasydata.net/api/nfl/fantasy/json/Timeframes/current' do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        time_json = JSON.parse(time_resp.body)
        @current_season = time_json["Season"] # eg 2019
        @current_week = time_json["Week"]
        @current_api_season = time_json["ApiSeason"] # eg 2019REG
        @current_season_type = time_json["SeasonType"] # (1=Regular Season, 2=Preseason, 3=Postseason, 4=Offseason)
        # find out when current week flips and run PlayerGame and Projections accordingly
    end



    def week_active_status

        # Make sure inactive week isn't the one from 2018 prior to games being played.. like on Tuesday, what does it look like - blank or wrong data?
        # Only run for RB/WR/TE
        # Do Inactives first - if active, don't check injury ... if inactive, run injury

        # If appears on both, create PlayerGame with ID, season, season type, week and flip needs_replacement
        # Then an if needs_replacement == true...
        # Can delete injury_status and active columns (use injury status for projections)
        # account for searching for replacement if on IR (if ir_id, then search that guy)
        # injury hash ID: injury
        # inactive hash ID: inactive
        # replacement: if ID is in injury hash && inactive hash
        # if in inactive hash && not in injury then 0 -- don't have to, will be 0s when he doesn't show up on stats API

        # NFL Injury Page:
        # doc = Nokogiri::HTML(open("http://www.nfl.com/injuries?week=#{@current_week}"))
        doc = Nokogiri::HTML(open("http://www.nfl.com/injuries?week=3"))
        text = doc.css("script").text
        report = text.scan(/gameStatus: "(\S*)".+?esbId: "(\S*)"/)
        injury_status_hash = {}
        report.each do |status, esb|
            if status != "--"
                injury_status_hash[esb] = status
            end
        end

        # NFL Inactives Page:
        # doc = Nokogiri::HTML(open("http://www.nfl.com/inactives?week=#{@current_week}"))
        doc = Nokogiri::HTML(open("http://www.nfl.com/inactives?week=3"))
        text = doc.css("script").text
        report = text.scan(/status: "(\S*)".+?esbId: ?"(\S*)"/)
        inactive_hash = {}
        report.each do |status, esb|
            if status == "Inactive"
                inactive_hash[esb] = status
            end
        end
    
        # PlayerGame.where(week: @current_week).each do |playergm|
        #   report.each do |status, id|
        #     if status != "--" && playergm.player.esb_id == id
        #         player.update(injury_status: status)
        #     end
        #   end
        # end

        # NFL Inactives:
        # doc = Nokogiri::HTML(open("http://www.nfl.com/inactives?week=#{@current_week}")) 
        # {player: "Derby A.J. ",   position: "TE", status: "Inactive", comments: "", lastName: "Derby", firstName: "A.J.", esbId: "DER139014"  },

        # if injured save player.player_week.status to questionable/doubtful/out
        # if inactive flip playerweek.active to false
        # if playerweek with same id has status != "healthy" and active false, flip replacement_needed to true 
    end

    def create_qb_k_games
    end

    def create_skill_player_games
        # current_timeframe
        # if @current_season_type == 1
            @current_season = 2018, @current_api_season = "2018REG", @current_week = 3, @current_season_type = 1 # delete once timeframe running

            stats_resp = Faraday.get "https://api.fantasydata.net/api/nfl/fantasy/json/PlayerGameStatsByWeek/#{@current_api_season}/#{@current_week}" do |req|
                req.params['key'] = ENV['FANTASY_DATA_KEY']
            end
            stats_json = JSON.parse(stats_resp.body)

            tlfl_players = Player.where(available: false)
            tlfl_skill_players = tlfl_players.where(position: "RB").or(tlfl_players.where(position: "WR")).or(tlfl_players.where(position: "TE"))
            tlfl_skill_players.each do |tlfl_player|
                if tlfl_player.ir_id
                    replacement_fd_id = Player.find_by(id: tlfl_player.ir_id).fd_id
                    player_stats = stats_json.find {|fd_player| fd_player["PlayerID"] == replacement_fd_id}
                else
                    player_stats = stats_json.find {|fd_player| fd_player["PlayerID"] == tlfl_player.fd_id}
                end             
                if player_stats
                    if game = PlayerGame.find_by(player_id: tlfl_player.id, season: @current_season, season_type: @current_season_type, week: @current_week)
                        game.update(
                            season: @current_season,
                            season_type: @current_season_type,
                            week: @current_week,
                            nfl_team: player_stats["Team"],
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
                            tlfl_team: tlfl_player.tlfl_team_id,
                            season: @current_season,
                            season_type: @current_season_type,
                            week: @current_week,
                            nfl_team: player_stats["Team"],
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
                else
                    # If player doesn't appear on FD's API (stats default to 0)
                    PlayerGame.create(
                        player_id: tlfl_player.id,
                        player_name: tlfl_player.full_name,
                        position: tlfl_player.position,
                        tlfl_team: tlfl_player.tlfl_team_id,
                        season: @current_season,
                        season_type: @current_season_type,
                        week: @current_week,
                        nfl_team: tlfl_player.nfl_abbrev
                    )
                end
            end
        # end
    end

    # Creates and Deletes players to show only active NFL players
    def update_available_players
        create_new_players
        fd_status_hash = {}
        @players_json.each do |fd_player|
            fd_status_hash[fd_player["PlayerID"]] = fd_player["Status"]
        end
        # Deletes players who aren't listed as "active" in database and aren't on TLFL team
        Player.all.each do |tlfl_player|
            if tlfl_player.available == true && fd_status_hash[tlfl_player.fd_id] != "Active"
                tlfl_player.destroy
            end
        end
    end

    # Updates player NFL teams (or if NFL team city/name changes)
    def update_player_nfl_data
        get_player_data
        @players_json.each do |fd_player| 
            Player.all.each do |tlfl_player|
                # Doesn't change a current TLFL player's team if he isn't on an NFL team anymore
                if (tlfl_player.available == false && fd_player["Team"]) || tlfl_player.available == true
                    if tlfl_player.fd_id == fd_player["PlayerID"] && tlfl_player.nfl_abbrev != fd_player["Team"]
                        tlfl_player.update(nfl_abbrev: fd_player["Team"], bye_week: fd_player["ByeWeek"], jersey: fd_player["Number"])
                    end
                end
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

    # -- OFFSEASON METHODS --
    

    # -- INITIAL CREATE METHODS --

end
