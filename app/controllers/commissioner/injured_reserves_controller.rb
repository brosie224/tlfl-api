module Commissioner
    class InjuredReservesController < ApplicationController
      before_action :commissioner_required
  
      def index
        # display all players on ir with link to edit
      end

      def new
        @weeks = []
        for week in 1..17 do
            @weeks << week
        end
      end

      def create
        raise params.inspect
      end

      def edit
        # option to activate or change the replacement player
      end

      def update
      end
    
    end
  end