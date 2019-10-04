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

    # # Checks if database name matches same as cbs - if different player, manually change cbs and esb IDs
    # def check_cbs_id
    #   @hash = {}
    #   cbs_resp = Faraday.get "http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=football&response_format=json"
    #   cbs_json = JSON.parse(cbs_resp.body)
    #   players = Player.all
    #   cbs_json["body"]["players"].each do |cbs_player|
    #     players.each do |player|
    #       if player.cbs_id == cbs_player["id"].to_i && player.full_name != cbs_player["fullname"]
    #         @hash[player.full_name] = cbs_player["fullname"]
    #       end
    #     end
    #   end
    # end
  
  end
end