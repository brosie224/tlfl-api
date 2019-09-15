module Api
    module V1
      class TlflTeamsController < ApplicationController

        def index
            render json: TlflTeam.order(:id)
        end

        def show
            render json: TlflTeam.find_by(id: params[:id])
        end

      end
    end
end