module Commissioner
  class ToolsController < ApplicationController
    before_action :commissioner_required

    def index
    end

    def create_new_players # link to button on tools page
      task = FdService.new
      task.create_new_players
      task.add_cbs_data_to_players
      redirect_to commissioner_path
    end

    def update_nfl_player_data # link to button on tools page
      task = FdService.new
      task.update_player_data
      redirect_to commissioner_path
    end
  
  end
end