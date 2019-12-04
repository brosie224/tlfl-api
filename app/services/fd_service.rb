# require 'open-uri'

class FdService

    def current_timeframe
        # {
        #     SeasonType: 1,
        #     Season: 2018,
        #     Week: 1,
        #     Name: "Week 1",
        #     ShortName: "Week 1",
        #     StartDate: "2018-09-01T00:00:00",
        #     EndDate: "2018-09-11T23:59:59",
        #     ApiSeason: "2018REG",
        #     ApiWeek: "1"
        # },

        # (1=Regular Season, 2=Preseason, 3=Postseason, 4=Offseason)

        time_resp = Faraday.get 'https://api.fantasydata.net/api/nfl/fantasy/json/Timeframes/current' do |req|
            req.params['key'] = ENV['FANTASY_DATA_KEY']
        end
        time_json = JSON.parse(time_resp.body)
        @current_season = time_json["Season"]
        @current_week = time_json["Week"]
        @current_api_season = time_json["ApiSeason"]

        # call current_timeframe in any method it's needed
    end

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

    # -- NEW SEASON UPDATES --

    # # Updates NFL FAs (Creates and Deletes to show correct available players)
    # def OLD_update_available_players
    #     # create_new_players
    #     get_player_data
    #     all_fd_ids = []
    #     # Deletes players who aren't listed as "active" in database and aren't on TLFL team
    #     @players_json.each do |fd_player|
    #         all_fd_ids << fd_player["PlayerID"]      
    #         Player.all.each do |tlfl_player|
    #             if tlfl_player.available == true && tlfl_player.fd_id == fd_player["PlayerID"] && fd_player["Status"] != "Active"
    #                 tlfl_player.destroy
    #             end
    #         end
    #     end
    #     # Deletes players who don't appear in the database and aren't on TLFL team
    #     Player.all.each do |tlfl_player|
    #         if tlfl_player.available == true && all_fd_ids.exclude?(tlfl_player.fd_id)
    #             tlfl_player.destroy
    #         end
    #     end
    # end

    # Updates NFL FAs (Creates and Deletes to show correct available players)
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


    # Updates players if on new NFL team (or if NFL team city/name changes)
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

end
