module Commissioner
    class TradesController < ApplicationController
        before_action :commissioner_required

        def new
            @trade = Trade.new
        end

        def create
            # Adds each player
            if params[:players]
                params[:players].each do |player_id|
                    player = Player.find(player_id)
                    player.tlfl_team_id = params[:tlfl_team][:id]
                    player.save
                end
            end
            # Adds DST
            if params[:dst]
                dst = TeamDst.find(params[:dst])
                dst.tlfl_team_id = params[:tlfl_team][:id]
                dst.save
            end
            redirect_to commissioner_players_available_path
        end

        def edit
        end

        def update
        end

        def destroy
        end

        private

        def set_trade
            @trade = Trade.find_by(id: params[:id])
        end
            
    end
end