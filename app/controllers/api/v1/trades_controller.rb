module Api
    module V1
      class TradesController < ApplicationController

        def index
            render json: Trade.where(season: 2019).order(:id)
        end

      end
    end
end