module Commissioner
    class TradesController < ApplicationController
        before_action :commissioner_required

        def index
            Date.today.month < 7 ? @year = Date.today.year - 1 : @year = Date.today.year
            @trades = Trade.where(season: @year).order(week: :desc)
        end

        def new
            @weeks = []
            for week in 1..17 do
                @weeks << week
            end
        end

        def create
            tm_one_name = TlflTeam.find_by(id: params[:tlfl_team_one][:id]).full_name
            tm_two_name = TlflTeam.find_by(id: params[:tlfl_team_two][:id]).full_name
            new_trade = Trade.create(season: Date.today.year, week: params[:weeks], team_one: tm_one_name, team_two: tm_two_name)
            # Trades each player
            if params[:players_one]
                params[:players_one].each do |player_id|
                    player = Player.find_by(id: player_id)
                    player.tlfl_team_id = params[:tlfl_team_two][:id]
                    player.save
                    new_trade.players_one << player.full_name
                    new_trade.save
                end
            end
            if params[:players_two]
                params[:players_two].each do |player_id|
                    player = Player.find_by(id: player_id)
                    player.tlfl_team_id = params[:tlfl_team_one][:id]
                    player.save
                    new_trade.players_two << player.full_name
                    new_trade.save
                end
            end
            # Trades DST
            if params[:dst_one]
                dst = TeamDst.find_by(id: params[:dst_one])
                dst.tlfl_team_id = params[:tlfl_team_two][:id]
                dst.save
                new_trade.dst_one = dst.full_name
                new_trade.save
            end
            if params[:dst_two]
                dst = TeamDst.find_by(id: params[:dst_two])
                dst.tlfl_team_id = params[:tlfl_team_one][:id]
                dst.save
                new_trade.dst_two = dst.full_name
                new_trade.save
            end
            # Trade each draft pick
            if params[:picks_one]
                params[:picks_one].each do |pick_id|
                    pick = DraftPick.find_by(id: pick_id)
                    pick.tlfl_team_id = params[:tlfl_team_two][:id]
                    pick.save
                    new_trade.picks_one << pick.full
                    new_trade.save
                end
            end
            if params[:picks_two]
                params[:picks_two].each do |pick_id|
                    pick = DraftPick.find_by(id: pick_id)
                    pick.tlfl_team_id = params[:tlfl_team_one][:id]
                    pick.save
                    new_trade.picks_two << pick.full
                    new_trade.save
                end
            end
            if params[:protection_one]
                team_one = TlflTeam.find_by(id: params[:tlfl_team_one][:id])
                team_two = TlflTeam.find_by(id: params[:tlfl_team_two][:id])
                team_one.protections -= 1
                team_two.protections += 1
                team_one.save
                team_two.save
                new_trade.includes_protection_one = true
                new_trade.save
            end
            if params[:protection_two]
                team_one = TlflTeam.find_by(id: params[:tlfl_team_one][:id])
                team_two = TlflTeam.find_by(id: params[:tlfl_team_two][:id])
                team_one.protections += 1
                team_two.protections -= 1
                team_one.save
                team_two.save
                new_trade.includes_protection_two = true
                new_trade.save
            end
            redirect_to new_commissioner_trade_path
        end

        def destroy
            trade = Trade.find_by(id: params[:id])
            trade.destroy
            redirect_to commissioner_trades_path
        end

    end
end