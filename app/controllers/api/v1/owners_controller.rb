module Api
    module V1
      class OwnersController < ApplicationController

        def index
            render json: Owner.order(:tlfl_team_id, :last_name, :first_name)
        end

        def show
            render json: Owner.find_by(id: params[:id])
        end

      end
    end
end