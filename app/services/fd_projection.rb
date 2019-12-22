require 'open-uri'
class FdProjection < TimeFrame

    def create_all_projected_games
        current_timeframe
        if @current_season_type == 1
            get_player_games
            create_qb_k_games
            create_rb_wr_te_games
            # FdTeam.new.create_dst_games
        end
    end

    def get_player_games
        # current_timeframe
        stats_resp = Faraday.get "https://api.fantasydata.net/api/nfl/fantasy/json/PlayerGameProjectionStatsByWeek/#{@current_api_season}/#{@current_week}" do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        @stats_json = JSON.parse(stats_resp.body)
    end

    def create_qb_k_games
        # get_player_games
        tlfl_players = Player.joins(:tlfl_team).where.not(tlfl_team_id: nil, bye_week: @current_week, tlfl_teams: {bye_week: @current_week})
        tlfl_qb_k = tlfl_players.where(position: "QB").or(tlfl_players.where(position: "K"))
        tlfl_qb_k.each do |tlfl_player|
            if player_stats = @stats_json.select {|fd_player| fd_player["Team"] == tlfl_player.nfl_abbrev && fd_player["Position"] == tlfl_player.position}
                pass_comp = player_stats.inject(0) {|sum, hash| sum + hash["PassingCompletions"]}
                pass_att = player_stats.inject(0) {|sum, hash| sum + hash["PassingAttempts"]}
                pass_yards = player_stats.inject(0) {|sum, hash| sum + hash["PassingYards"]}
                pass_td = player_stats.inject(0) {|sum, hash| sum + hash["PassingTouchdowns"]}
                pass_int = player_stats.inject(0) {|sum, hash| sum + hash["PassingInterceptions"]}
                rushes = player_stats.inject(0) {|sum, hash| sum + hash["RushingAttempts"]}
                rush_yards = player_stats.inject(0) {|sum, hash| sum + hash["RushingYards"]}
                rush_td = player_stats.inject(0) {|sum, hash| sum + hash["RushingTouchdowns"]}
                receptions = player_stats.inject(0) {|sum, hash| sum + hash["Receptions"]}
                rec_yards = player_stats.inject(0) {|sum, hash| sum + hash["ReceivingYards"]}
                rec_td = player_stats.inject(0) {|sum, hash| sum + hash["ReceivingTouchdowns"]}
                punt_ret_td = player_stats.inject(0) {|sum, hash| sum + hash["PuntReturnTouchdowns"]}
                kick_ret_td = player_stats.inject(0) {|sum, hash| sum + hash["KickReturnTouchdowns"]}
                two_pt_pass = player_stats.inject(0) {|sum, hash| sum + hash["TwoPointConversionPasses"]}
                two_pt_rush = player_stats.inject(0) {|sum, hash| sum + hash["TwoPointConversionRuns"]}
                two_pt_rec = player_stats.inject(0) {|sum, hash| sum + hash["TwoPointConversionReceptions"]}
                fgm = player_stats.inject(0) {|sum, hash| sum + hash["FieldGoalsMade"]}
                fga = player_stats.inject(0) {|sum, hash| sum + hash["FieldGoalsAttempted"]}
                pat = player_stats.inject(0) {|sum, hash| sum + hash["ExtraPointsMade"]}
                if game = ProjectedPlayerGame.find_by(player_id: tlfl_player.id, season: @current_season, season_type: @current_season_type, week: @current_week)
                    game.update(
                        player_name: tlfl_player.full_name,
                        position: tlfl_player.position,
                        tlfl_team_id: tlfl_player.tlfl_team_id,
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
                else
                    ProjectedPlayerGame.create(
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
                ProjectedPlayerGame.create(
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
        # get_player_games
        week_injury_status
        @tlfl_skill_players.each do |tlfl_player|
            tlfl_player.ir_id ? fd_id = Player.find_by(id: tlfl_player.ir_id).fd_id : fd_id = tlfl_player.fd_id
            player_game = ProjectedPlayerGame.find_by(player_id: tlfl_player.id, season: @current_season, season_type: @current_season_type, week: @current_week)
            if player_stats = @stats_json.find {|fd_player| fd_player["PlayerID"] == fd_id}
                if player_game
                    player_game.update(
                        player_name: tlfl_player.full_name,
                        position: tlfl_player.position,
                        tlfl_team_id: tlfl_player.tlfl_team_id,
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
                else
                    ProjectedPlayerGame.create(
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
                # If player doesn't appear on FD's API and game wasn't previously created due to injury (stats default to 0)
                ProjectedPlayerGame.create(
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

    def week_injury_status
        # current_timeframe
        # Injuries
        doc = Nokogiri::HTML(open("http://www.nfl.com/injuries?week=#{@current_week}"))
        text = doc.css("script").text
        matches = text.scan(/gameStatus: "(\S*)".+?esbId: ?"(\S*)"/)
        injury_status_hash = {}
        matches.each do |status, esb|
            injury_status_hash[esb] = status if status != "--"
        end
        # Create/Update PlayerGame if TLFL player is injured
        tlfl_players = Player.joins(:tlfl_team).where.not(tlfl_team_id: nil, bye_week: @current_week, tlfl_teams: {bye_week: @current_week})
        @tlfl_skill_players = tlfl_players.where(position: "RB").or(tlfl_players.where(position: "WR")).or(tlfl_players.where(position: "TE"))
        @tlfl_skill_players.each do |tlfl_player|
            player_game = ProjectedPlayerGame.find_by(player_id: tlfl_player.id, season: @current_season, season_type: @current_season_type, week: @current_week)
            tlfl_player.ir_id ? esb = Player.find_by(id: tlfl_player.ir_id).esb_id : esb = tlfl_player.esb_id
            if injury_status_hash[esb]
                if player_game
                    player_game.update(
                        player_name: tlfl_player.full_name,
                        position: tlfl_player.position,
                        tlfl_team_id: tlfl_player.tlfl_team_id,
                        nfl_team: tlfl_player.nfl_abbrev,
                        injury_status: injury_status_hash[esb]
                    )
                else
                    ProjectedPlayerGame.create(
                        player_id: tlfl_player.id,
                        player_name: tlfl_player.full_name,
                        position: tlfl_player.position,
                        tlfl_team_id: tlfl_player.tlfl_team_id,
                        season: @current_season,
                        season_type: @current_season_type,
                        week: @current_week,
                        nfl_team: tlfl_player.nfl_abbrev,
                        injury_status: injury_status_hash[esb]
                    )
                end
            end
        end
    end

end