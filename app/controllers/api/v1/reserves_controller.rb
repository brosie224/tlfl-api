module Api
    module V1
      class ReservesController < ApplicationController

        def index
          render json: Player.where.not(ir_id: nil).order(:last_name, :first_name)
        end

      end
    end
end