module Commissioner
    class PlayersController < ApplicationController
        before_action :commissioner_required

        def available
            @players = Player.order(:last_name, :first_name).where(tlfl_team: nil)
        end

        def add_to_team
            params[:players].each do |player_id|
                player = Player.find(player_id)
                player.tlfl_team_id = params[:tlfl_team][:id]
                player.save
            end
            redirect_to commissioner_players_available_path
        end
    
    end
end