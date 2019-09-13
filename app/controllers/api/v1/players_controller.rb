module Api
    module V1
      class PlayersController < ApplicationController

        def index
          render json: Player.order(:last_name, :first_name)
        end

        def show
        end

        def tlfl
        end

        def available
          render json: Player.order(:last_name, :first_name).where(tlfl_team: nil)
        end

      end
    end
end