class FdTeam < TimeFrame

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
