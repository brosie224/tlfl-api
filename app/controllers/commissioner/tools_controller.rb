module Commissioner
  class ToolsController < ApplicationController
    before_action :commissioner_required

    def index
    end

    # NEW SEASON

    def update_available_players # link to button on tools page
      task = FdService.new
      task.update_available_players
      task.update_player_nfl_data
      task.add_cbs_data_to_players
      flash[:notice] = "Available players updated."
      redirect_to commissioner_path
    end

    def update_team_data # link to button on tools page
      task = FdService.new
      task.update_team_dst_data
      task.update_tlfl_team_data
      flash[:notice] = "Team data updated."
      redirect_to commissioner_path
    end
  
  end
end