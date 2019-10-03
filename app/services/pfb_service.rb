class PfbService

    def get_schedule
        sched_resp = Faraday.post 'https://profootballapi.com/schedule' do |req|
            req.params['api_key'] = ENV['PFB_DATA_KEY'] # <-- Free Trial
            req.params['year'] = Date.today.year
            req.params['season_type'] = "REG"
        end
        sched_json = JSON.parse(sched_resp.body)
        sched_json.each do |game|
            ScheduleGame.find_or_create_by(pfb_id: game["id"]) do |new_game|
                new_game.home_team = game["home"]
                new_game.home_team = "LAR" if new_game.home_team == "LA"
                new_game.away_team = game["away"]
                new_game.away_team = "LAR" if new_game.away_team == "LA"
                new_game.season = game["year"]
                new_game.week = game["week"]
                new_game.month = game["month"]
                new_game.day = game["day"]
                new_game.season_type = game["season_type"]
            end
        end
    end

    def test_pfb
        players_resp = Faraday.post 'https://profootballapi.com/players' do |req|
            req.params['api_key'] = ENV['PFB_DATA_KEY'] # <-- Free Trial
            req.params['year'] = Date.today.year
            req.params['season_type'] = "REG"
            req.params['stats_type'] = 'offense'
            req.params['week'] = '4'
        end
        players_json = JSON.parse(players_resp.body)
        players_json.each do |player| # gets each game.. then need to go thru each player (regex?), then passing/rushing/receiving/kicking/special?
            puts player
        end

        # Goff: "00-0033106"

        # Schedule has PFB game IDs. For each current week, put those game IDs in array and iterate over that for live stats?

    end

end