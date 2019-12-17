class FdTeam < TimeFrame

    # -- WEEKLY STATS -- 

    def get_dst_games
        stats_resp = Faraday.get "https://api.fantasydata.net/api/nfl/fantasy/json/FantasyDefenseByGame/2018REG/#{@current_api_season}/#{@current_week}" do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        @stats_json = JSON.parse(stats_resp.body)
    end

    def create_dst_games
        current_timeframe
        if @current_season_type == 1
            get_dst_games
            tlfl_dsts = TeamDst.where.not(bye_week: @current_week)
            @tlfl_dsts.each do |tlfl_dst|
                
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
    end

    # -- OFFSEASON METHODS --
    
    def update_team_dst_data
        # If there's a new/relocated team, check abbreviation compared to what cbs and pfb uses
        teams_resp = Faraday.get 'https://api.fantasydata.net/api/nfl/fantasy/json/Teams' do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        teams_json = JSON.parse(teams_resp.body)
        teams_json.each do |team|
            TeamDst.all.each do |dst|
                if dst.fd_id == team["TeamID"]
                    dst.update(city: team["City"], nickname: team["Name"], nfl_abbrev: team["Key"], bye_week: team["ByeWeek"], 
                        logo: team["WikipediaLogoUrl"], word_mark: team["WikipediaWordMarkUrl"], fd_player_id: team["PlayerID"])
                end
            end
        end
    end

    def update_tlfl_team_data
        # If there's a new/relocated team, check abbreviation compared to what cbs and pfb uses
        teams_resp = Faraday.get 'https://api.fantasydata.net/api/nfl/fantasy/json/Teams' do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        teams_json = JSON.parse(teams_resp.body)
        teams_json.each do |team|
            TlflTeam.all.each do |tlfl_team|
                if tlfl_team.fd_id == team["TeamID"]
                    tlfl_team.update(city: team["City"], nickname: team["Name"], abbreviation: team["Key"], conference: team["Conference"], division: team["Division"], 
                        bye_week: team["ByeWeek"], logo: team["WikipediaLogoUrl"], word_mark: team["WikipediaWordMarkUrl"], primary_color: team["PrimaryColor"], 
                        secondary_color: team["SecondaryColor"], tertiary_color: team["TertiaryColor"], quaternary_color: team["QuaternaryColor"])
                end
            end
        end
    end

    # -- INITIAL CREATE METHODS --

    def create_tlfl_teams
        teams_resp = Faraday.get 'https://api.fantasydata.net/api/nfl/fantasy/json/Teams' do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        teams_json = JSON.parse(teams_resp.body)
        teams_json.each do |team|
            TlflTeam.find_or_create_by(fd_id: team["TeamID"]) do |new_team|
                new_team.city = team["City"]
                new_team.nickname = team["Name"]
                new_team.abbreviation = team["Key"]
                new_team.conference = team["Conference"]
                new_team.division = team["Division"]
                new_team.bye_week = team["ByeWeek"]
                new_team.logo = team["WikipediaLogoUrl"]
                new_team.word_mark = team["WikipediaWordMarkUrl"]
                new_team.primary_color = team["PrimaryColor"]
                new_team.secondary_color = team["SecondaryColor"]
                new_team.tertiary_color = team["TertiaryColor"]
                new_team.quaternary_color = team["QuaternaryColor"]
            end
        end
    end

    def create_team_dsts
        teams_resp = Faraday.get 'https://api.fantasydata.net/api/nfl/fantasy/json/Teams' do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        teams_json = JSON.parse(teams_resp.body)
        teams_json.each do |team|
            TeamDst.find_or_create_by(fd_id: team["TeamID"]) do |new_team|
                new_team.city = team["City"]
                new_team.nickname = team["Name"]
                new_team.nfl_abbrev = team["Key"]
                new_team.bye_week = team["ByeWeek"]
                new_team.logo = team["WikipediaLogoUrl"]
                new_team.word_mark = team["WikipediaWordMarkUrl"]
                new_team.fd_player_id = team["PlayerID"]
            end
        end
    end

end
