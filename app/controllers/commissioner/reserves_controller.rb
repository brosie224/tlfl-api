module Commissioner
    class ReservesController < ApplicationController
      before_action :commissioner_required
      before_action :get_weeks, only: [:new, :activate_or_replace]
  
      def index
        @players = Player.where.not(ir_id: nil).order(:last_name, :first_name)
      end

      def new
      end

      def create
        Reserve.create(category: "new", season: Date.today.year, week: params[:week], named_player: params[:rs_player], replacement_player: params[:replacement])
        rs_player = Player.find_by(id: params[:rs_player])
        rs_player.ir_id = params[:replacement]
        rs_player.ir_week = params[:week]
        rs_player.save
        replacement_player = Player.find_by(id: params[:replacement])
        replacement_player.available = false
        replacement_player.save
        flash[:notice] = "#{rs_player.full_name} has been reserved."
        redirect_to new_commissioner_reserf_path
      end

      def activate_or_replace
        @rs_player = Player.find_by(id: params[:rs_player])
        @replacement_player = Player.find_by(id: params[:replacement])
        @new_options = Player.where(nfl_abbrev: @rs_player.nfl_abbrev, position: @rs_player.position, available: true)
      end

      def activate
        Reserve.create(category: "activate", season: Date.today.year, week: params[:week], named_player: params[:rs_player], replacement_player: params[:replacement])
        rs_player = Player.find_by(id: params[:rs_player])
        rs_player.ir_id = nil
        rs_player.ir_week = nil
        rs_player.save
        replacement_player = Player.find_by(id: params[:replacement])
        replacement_player.available = true
        replacement_player.save
        flash[:notice] = "#{rs_player.full_name} has been activated."
        redirect_to commissioner_reserves_path
      end

      def change_replacement
        Reserve.create(category: "change", season: Date.today.year, week: params[:week], named_player: params[:rs_player], replacement_player: params[:new_replacement])
        rs_player = Player.find_by(id: params[:rs_player])
        rs_player.ir_id = params[:new_replacement]
        rs_player.save
        old_replacement = Player.find_by(id: params[:old_replacement])
        old_replacement.available = true
        old_replacement.save
        new_replacement = Player.find_by(id: params[:new_replacement])
        new_replacement.available = false
        new_replacement.save
        flash[:notice] = "Replacement changed to #{new_replacement.full_name}"
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