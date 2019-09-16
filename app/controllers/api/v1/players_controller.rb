module Api
    module V1
      class PlayersController < ApplicationController

        def index
          render json: Player.order(:last_name, :first_name)
        end

        def show
          render json: Player.find_by(id: params[:id])
        end

        def tlfl
          render json: Player.order(:last_name, :first_name).where.not(tlfl_team: nil)
        end

        def available
          render json: Player.order(:last_name, :first_name).where(tlfl_team: nil)
        end

        # Need to render TeamDst?

      end
    end
end