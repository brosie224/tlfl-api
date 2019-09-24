module Commissioner
    class InjuredReservesController < ApplicationController
      before_action :commissioner_required
  
      def index
        @players = Player.where.not(fd_ir: nil).order(:last_name, :first_name)
      end

      def new
        @weeks = []
        for week in 1..17 do
            @weeks << week
        end
      end

      def create
        # raise params.inspect
        ir_player = Player.find_by(id: params[:ir_player])
        replacement_player = Player.find_by(id: params[:ir_replacement])
        replacement_player.available = false
        replacement_player.save
        ir_player.ir_fd_id = replacement_player.fd_id
        ir_player.ir_week = params[:weeks]
        ir_player.save
        redirect_to new_commissioner_injured_reserf_path
      end

      def edit
        # option to activate or change the replacement player
        # when activate, make ir_fd_id and ir_week nil, change replacement player.available to true
      end

      def update
      end
    
    end
  end