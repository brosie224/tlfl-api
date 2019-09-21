module Commissioner
    class TradesController < ApplicationController
        before_action :commissioner_required

        def index
            # render all with link to delete
        end

        def new
            @weeks = []
            for week in 1..17 do
                @weeks << week
            end
        end

        def create
        # raise params.inspect
            # # Trades each player
            # if params[:players_one]
            #     params[:players_one].each do |player_id|
            #         player = Player.find(player_id)
            #         player.tlfl_team_id = params[:tlfl_team_two][:id]
            #         player.save
            #     end
            # end
            # if params[:players_two]
            #     params[:players_two].each do |player_id|
            #         player = Player.find(player_id)
            #         player.tlfl_team_id = params[:tlfl_team_one][:id]
            #         player.save
            #     end
            # end
            # # Trades DST
            # if params[:dst_one]
            #     dst = TeamDst.find(params[:dst_one])
            #     dst.tlfl_team_id = params[:tlfl_team_two][:id]
            #     dst.save
            # end
            # if params[:dst_two]
            #     dst = TeamDst.find(params[:dst_two])
            #     dst.tlfl_team_id = params[:tlfl_team_one][:id]
            #     dst.save
            # end
            # # Trade each draft pick
            # if params[:picks_one]
            #     params[:picks_one].each do |pick_id|
            #         pick = DraftPick.find(pick_id)
            #         pick.tlfl_team_id = params[:tlfl_team_two][:id]
            #         pick.save
            #     end
            # end
            # if params[:picks_two]
            #     params[:picks_two].each do |pick_id|
            #         pick = DraftPick.find(pick_id)
            #         pick.tlfl_team_id = params[:tlfl_team_one][:id]
            #         pick.save
            #     end
            # end
            # if params[:protection_one]
            #     team_one = TlflTeam.find(params[:tlfl_team_one][:id])
            #     team_two = TlflTeam.find(params[:tlfl_team_two][:id])
            #     team_one.protections -= 1
            #     team_two.protections += 1
            #     team_one.save
            #     team_two.save
            # end
            # if params[:protection_two]
            #     team_one = TlflTeam.find(params[:tlfl_team_one][:id])
            #     team_two = TlflTeam.find(params[:tlfl_team_two][:id])
            #     team_one.protections += 1
            #     team_two.protections -= 1
            #     team_one.save
            #     team_two.save
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