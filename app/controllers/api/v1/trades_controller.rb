module Api
    module V1
      class TradesController < ApplicationController

        def index
          Date.today.month < 7 ? @season = Date.today.year - 1 : @season = Date.today.year
          render json: Trade.where(season: @season).order(week: :desc, id: :desc)
        end

        def show
          render json: Trade.find_by(id: params[:id])
        end

      end
    end
end