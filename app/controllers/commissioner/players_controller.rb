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

        # Edit Seniority
            # List out each TLFL RB/WR by nfl team, position, seniority
            # Have dropdown for seniority
    
        # Place on IR
            # when submit, if on_ir then post the transaction using fd_id and ir_id

    end
end