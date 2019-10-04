module Api
    module V1
        class ScheduleGamesController < ApplicationController
            before_action :commissioner_required
    
            def index
                render json: ScheduleGame.order(:week, :pfb_id)
            end
        
        end
    end
end