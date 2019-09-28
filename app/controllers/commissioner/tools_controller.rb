module Commissioner
  class ToolsController < ApplicationController
    before_action :commissioner_required

    def index
    end

    def update_available_players # link to button on tools page
      task = FdService.new
      task.update_available_players
      task.update_player_nfl_data
      task.add_cbs_data_to_players
      flash[:notice] = "Available Players Updated."
      redirect_to commissioner_path
    end

    def update_player_nfl_data # link to button on tools page
      # task = FdService.new
      # task.update_player_nfl_data
      # redirect_to commissioner_path
    end
  
  end
end