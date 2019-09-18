module Api
    module V1
      class TradesController < ApplicationController

        def index
          render json: Trade.where(season: 2019).order(:id)
        end

        def show
          render json: Trade.find_by(id: params[:id])
        end

      end
    end
end