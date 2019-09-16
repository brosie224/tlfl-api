module Api
    module V1
      class TeamDstsController < ApplicationController

        def index
          render json: TeamDst.order(:city, :nickname)
        end

        def show
          render json: TeamDst.find_by(id: params[:id])
        end

      end
    end
end