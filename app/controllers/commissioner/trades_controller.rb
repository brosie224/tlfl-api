module Commissioner
    class TradesController < ApplicationController
        before_action :commissioner_required

        def index
            # render all with link to delete
        end

        def new
        end

        def create
            raise params.inspect
            # # Adds each player
            # if params[:players]
            #     params[:players].each do |player_id|
            #         player = Player.find(player_id)
            #         player.tlfl_team_id = params[:tlfl_team][:id]
            #         player.save
            #     end
            # end
            # # Adds DST
            # if params[:dst]
            #     dst = TeamDst.find(params[:dst])
            #     dst.tlfl_team_id = params[:tlfl_team][:id]
            #     dst.save
            # end
            # redirect_to new_commissioner_trade_path
        end

        def destroy
            # Will delete the posting of the move, but the execution will remain?
            @trade = Trade.find_by(id: params[:id])
            @trade.destroy
            redirect_to new_commissioner_trade_path
        end

        # private

        # def trade_params
        #     params.require(:trade).permit(:season, :week, :team_one, :team_two, :assets_one, :assets_two, 
        #     :offseason, :includes_protection_one, :includes_protection_two)
        # end
            
    end
end