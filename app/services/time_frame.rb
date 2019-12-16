class TimeFrame

    def current_timeframe
        # time_resp = Faraday.get 'https://api.fantasydata.net/api/nfl/fantasy/json/Timeframes/current' do |req|
        #     req.params['key'] = ENV['FANTASY_DATA_KEY']
        # end
        # time_json = JSON.parse(time_resp.body)
        # @current_season = time_json["Season"] # eg 2019
        # @current_week = time_json["Week"]
        # @current_api_season = time_json["ApiSeason"] # eg 2019REG
        # @current_season_type = time_json["SeasonType"] # (1=Regular Season, 2=Preseason, 3=Postseason, 4=Offseason)
        # # find out when current week flips and run PlayerGame and Projections accordingly

        @current_api_season = "2018REG" # delete once timeframe running
        @current_season = 2018 # delete once timeframe running
        @current_week = 3 # delete once timeframe running
        @current_season_type = 1 # delete once timeframe running
    end

end