module Commissioner
    class InjuredReservesController < ApplicationController
      before_action :commissioner_required
  
      def index
        @players = Player.where.not(ir_id: nil).order(:last_name, :first_name)
      end

      def new
        @weeks = []
        for week in 1..17 do
            @weeks << week
        end
      end

      def create
        ir_player = Player.find_by(id: params[:ir_player])
        ir_player.ir_id = params[:ir_replacement]
        ir_player.ir_week = params[:weeks]
        ir_player.save
        replacement_player = Player.find_by(id: params[:ir_replacement])
        replacement_player.available = false
        replacement_player.save
        flash[:notice] = "#{ir_player.full_name} has been reserved."
        redirect_to new_commissioner_injured_reserf_path
      end

      def activate
        ir_player = Player.find_by(id: params[:ir_player])
        ir_player.ir_id = nil
        ir_player.ir_week = nil
        ir_player.save
        replacement_player = Player.find_by(id: params[:replacement])
        replacement_player.available = true
        replacement_player.save
        flash[:notice] = "#{ir_player.full_name} has been activated."
        redirect_to commissioner_injured_reserves_path
      end

      def change_replacement
      end
    
    end
  end