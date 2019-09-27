module Commissioner
    class InjuredReservesController < ApplicationController
      before_action :commissioner_required
  
      def index
        @players = Player.where.not(ir_fd_id: nil).order(:last_name, :first_name)
      end

      def new
        @weeks = []
        for week in 1..17 do
            @weeks << week
        end
      end

      def create
        raise params.inspect
        ir_player = Player.find_by(id: params[:ir_player])
        replacement_player = Player.find_by(id: params[:ir_replacement])
        ir_player.ir_fd_id = replacement_player.fd_id
        ir_player.ir_week = params[:weeks]
        ir_player.save
        replacement_player.available = false
        replacement_player.save
        flash[:notice] = "#{ir_player.full_name} has been reserved."
        redirect_to new_commissioner_injured_reserf_path
      end

      def activate
        raise params.inspect
        # ir_player = Player.find_by(id: params[:ir_player])
        # ir_player.ir_fd_id = nil
        # ir_player.ir_week = nil
        # ir_player.save
        # replacement_player = Player.find_by(ir_fd_id: params[:replacement])
        # replacement_player.available = true
        # replacement_player.save
        # flash[:notice] = "#{ir_player.full_name} has been activated."
        # redirect_to commissioner_injured_reserves_path
      end

      def change_replacement
      end
    
    end
  end