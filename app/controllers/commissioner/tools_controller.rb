module Commissioner
  class ToolsController < ApplicationController
    before_action :commissioner_required

    def index
    end

    # NEW SEASON

    # Creates new players, deletes inactive players and players not in league, updates player if new team, adds cbs data
    def update_available_players
      FdPlayer.new.update_all_player_info
      flash[:notice] = "Players updated."
      redirect_to commissioner_path
    end

    # Updates data for TLFL teams and Team DSTs
    def update_team_data # link to button on tools page
      task = FdTeam.new
      task.update_team_dst_data
      task.update_tlfl_team_data
      flash[:notice] = "Team data updated."
      redirect_to commissioner_path
    end

    
    # Checks if database name matches same as cbs - if different player, manually change cbs and esb IDs
    def check_cbs_id
      @hash = {}
      cbs_resp = Faraday.get "http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=football&response_format=json"
      cbs_json = JSON.parse(cbs_resp.body)
      players = Player.all
      cbs_json["body"]["players"].each do |cbs_player|
        players.each do |player|
          if player.cbs_id == cbs_player["id"].to_i && player.full_name != cbs_player["fullname"]
            @hash[player.full_name] = cbs_player["fullname"]
          end
        end
      end
    end
  
  end
end