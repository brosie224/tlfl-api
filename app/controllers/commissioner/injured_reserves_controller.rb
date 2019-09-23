module Commissioner
    class InjuredReservesController < ApplicationController
      before_action :commissioner_required
  
      def index
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
      end

      def update
      end
    
    end
  end