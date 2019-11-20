class NewSeason

    # Global search for last year (ie 2019) and change to current year

    # Offseason
        # Assign overall to each DraftPick
            # create new array of picks (eg [{team: Saints, round: 1, overall, 32}, {team: Saints, round: 2, overall, 64}] ) 
            # DraftPick.all.each do, new.each do00
                # if pick.team == new.team && pick.round == new.round then pick.overall = new.overall

        # Reset IR
            # Change all player ir_id, ir_week to nil

        def set_keepers # put in players controller?
        end

        # After keepers set, reset non-keeper's seniority (if no team, seniority = 1)

        # FdService methods to run:
            # create_new_players (to add rookies/new players)
            # update_tlfl_team_data
            # update_player_data
            # update_teams_dst_data

    # After Draft

        def generate_draft_picks()
            DraftPick.all.each do |pick|
                pick.tlfl_team_id = nil
            end
            TlflTeam.all.each do |tm|
                for rd in 1..6 do
                    tm.draft_picks.build(team: tm.full_name, year: Date.today.year + 1, round: rd)
                    tm.save
                end
            end
        end

        # Reset all TLFL team protections back to 3

    # After Rosters are entered 

        def reset_player_available
            Player.all.each do |player|
                if player.tlfl_team_id == nil
                    player.available = true
                    player.save
                else
                    player.available = false
                    player.save
                end
            end
        end
        
end
