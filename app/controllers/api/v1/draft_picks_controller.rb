module Api
    module V1
      class DraftPicksController < ApplicationController

        def index
          render json: DraftPick.order(:id)
        end

        def show
          render json: DraftPick.find_by(id: params[:id])
        end

      end
    end
end