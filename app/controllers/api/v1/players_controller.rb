module Api
    module V1
      class PlayersController < ApplicationController

        def index
          render json: Player.order(:nfl_abbrev, :jersey)
        end

        def show
        end

        def tlfl
        end

        def available
        end

      end
    end
end