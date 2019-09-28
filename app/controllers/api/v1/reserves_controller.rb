module Api
    module V1
      class ReservesController < ApplicationController

        def index
          Date.today.month < 7 ? @season = Date.today.year - 1 : @season = Date.today.year
          render json: Reserve.where(season: @season).order(week: :desc)
        end

      end
    end
end