module Commissioner
    class PlayersController < ApplicationController
        before_action :commissioner_required

        def available
            @players = Player.order(:last_name, :first_name).where(tlfl_team: nil).sort_position
            @dsts = TeamDst.order(:city, :nickname).where(tlfl_team: nil)
        end

        def add_to_team
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
    
    end
end