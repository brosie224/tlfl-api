class FdTeam < TimeFrame

    # -- WEEKLY STATS -- 

    def get_dst_games
        current_timeframe
        stats_resp = Faraday.get "https://api.fantasydata.net/api/nfl/fantasy/json/FantasyDefenseByGame/#{@current_api_season}/#{@current_week}" do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        @stats_json = JSON.parse(stats_resp.body)
    end

    def create_dst_games
        get_dst_games
        # tlfl_dsts = TeamDst.where.not(bye_week: @current_week)
        tlfl_dsts = TeamDst.joins(:tlfl_team).where.not(bye_week: @current_week, tlfl_teams: {bye_week: @current_week})
        tlfl_dsts.each do |tlfl_dst|
            dst_game = TeamDstGame.find_by(team_dst_id: tlfl_dst.id, season: @current_season, season_type: @current_season_type, week: @current_week)
            if dst_stats = @stats_json.find {|fd_dst| fd_dst["PlayerID"] == tlfl_dst.fd_player_id}
                if dst_game
                    dst_game.update(
                        points_allowed: dst_stats["PointsAllowed"],
                        touchdowns: dst_stats["TouchdownsScored"],
                        sacks: dst_stats["Sacks"],
                        fumbles_recovered: dst_stats["FumblesRecovered"],
                        interceptions: dst_stats["Interceptions"],
                        safeties: dst_stats["Safeties"],
                        two_pt_ret: dst_stats["TwoPointConversionReturns"]
                    )
                    tlfl_players = PlayerGame.where(week: @current_week, nfl_team: tlfl_dst.nfl_abbrev)
                    tlfl_returns = tlfl_players.inject(0) {|sum, hash| sum + hash[:punt_ret_td]} + tlfl_players.inject(0) {|sum, hash| sum + hash[:kick_ret_td]}
                    dst_game.update(touchdowns: dst_game.touchdowns - tlfl_returns)
                else
                    dst_game = TeamDstGame.create(
                        team_dst_id: tlfl_dst.id,
                        team_name: tlfl_dst.full_name,
                        tlfl_team_id: tlfl_dst.tlfl_team_id,
                        season: @current_season,
                        season_type: @current_season_type,
                        week: @current_week,
                        nfl_abbrev: tlfl_dst.nfl_abbrev,
                        points_allowed: dst_stats["PointsAllowed"],
                        touchdowns: dst_stats["TouchdownsScored"],
                        sacks: dst_stats["Sacks"],
                        fumbles_recovered: dst_stats["FumblesRecovered"],
                        interceptions: dst_stats["Interceptions"],
                        safeties: dst_stats["Safeties"],
                        two_pt_ret: dst_stats["TwoPointConversionReturns"]
                    )
                    tlfl_players = PlayerGame.where(week: @current_week, nfl_team: tlfl_dst.nfl_abbrev)
                    tlfl_returns = tlfl_players.inject(0) {|sum, hash| sum + hash[:punt_ret_td]} + tlfl_players.inject(0) {|sum, hash| sum + hash[:kick_ret_td]}
                    dst_game.update(touchdowns: dst_game.touchdowns - tlfl_returns)
                end
            else
                TeamDstGame.create(
                    team_dst_id: tlfl_dst.id,
                    team_name: tlfl_dst.full_name,
                    tlfl_team_id: tlfl_dst.tlfl_team_id,
                    season: @current_season,
                    season_type: @current_season_type,
                    week: @current_week,
                    nfl_abbrev: tlfl_dst.nfl_abbrev
                )
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
