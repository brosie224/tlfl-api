module Commissioner
    class ReservesController < ApplicationController
      before_action :commissioner_required
      before_action :get_weeks, only: [:new, :replacement_options]
  
      def index
        @players = Player.where.not(ir_id: nil).order(:last_name, :first_name)
      end

      def new
      end

      def create
        ir_player = Player.find_by(id: params[:ir_player])
        ir_player.ir_id = params[:ir_replacement]
        ir_player.ir_week = params[:week]
        ir_player.save
        replacement_player = Player.find_by(id: params[:ir_replacement])
        replacement_player.available = false
        replacement_player.save
        flash[:notice] = "#{ir_player.full_name} has been reserved."
        redirect_to new_commissioner_reserf_path
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
        redirect_to commissioner_reserves_path
      end

      def replacement_options
        @ir_player = Player.find_by(id: params[:ir_player])
        @replacement_player = Player.find_by(id: params[:replacement])
        @new_options = Player.where(nfl_abbrev: @ir_player.nfl_abbrev, position: @ir_player.position, available: true)
      end

      def change_replacement
        raise params.inspect
        # ir_player =
        # old_replacement =
        # new_replacement =
        redirect_to commissioner_reserves_path
      end

      private

      def get_weeks
        @weeks = []
        for week in 1..17 do
            @weeks << week
        end
      end
    
    end
  end