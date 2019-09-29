module Commissioner
    class PlayersController < ApplicationController
        before_action :commissioner_required

        def assign
            @players = Player.order(:last_name, :first_name).where(available: true).sort_position
            @dsts = TeamDst.order(:city, :nickname).where(tlfl_team: nil)
        end

        def add_to_team
            # Adds each player
            if params[:players]
                params[:players].each do |player_id|
                    player = Player.find_by(id: player_id)
                    player.tlfl_team_id = params[:tlfl_team_assign][:id]
                    player.save
                end
            end
            # Adds DST
            if params[:dst]
                dst = TeamDst.find_by(id: params[:dst])
                dst.tlfl_team_id = params[:tlfl_team_assign][:id]
                dst.save
            end
            @tlfl_team = TlflTeam.find_by(id: params[:tlfl_team_assign][:id]) 
            flash[:notice] = "Players added to #{@tlfl_team.nickname}"
            redirect_to commissioner_players_assign_path
        end

        def edit_seniority
            @teams = TlflTeam.order(:city, :nickname)
            @players = Player.order(:nfl_abbrev, :position, :seniority).select do |player|
                player.tlfl_team_id != nil && (player.position == "RB" || player.position == "WR")
            end
        end

        def update_seniority
            params[:players].keys.each do |id|
                player = Player.find_by(id: id)
                player.seniority = params[:players][id][:seniority]
                player.save
            end
            flash[:notice] = "Changes saved."
            redirect_to commissioner_players_edit_seniority_path
        end

        private

        def player_params
            params.require(:player).permit(:seniority)
        end
    
    end
end