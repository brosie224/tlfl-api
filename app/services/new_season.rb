class NewSeason

    # Do global search for last year (ie 2019) and change to current year

    # Organize everything by order of when run; Group together based on order

    # Offseason
        # Assign overall to each DraftPick
            # create new array of picks (eg [{team: Saints, round: 1, overall, 32}, {team: Saints, round: 2, overall, 64}] ) 
            # then assign .overall based on new array
l
        # Reset players who were on IR
        def reset_ir
            ir_players = Player.where.not(ir_id: nil).or(Player.where.not(ir_week: nil))
            ir_players.all.each do |player|
                player.update(ir_id: nil, ir_week: nil)
            end
        end

        def set_keepers # put in players controller?
            # if player not checked, then tlfl_team_id = nil
        end

        # After keepers set, reset non-keeper's seniority (if no team, seniority = 1)

        # To-Do List w/ corresponding methods:
            # Add rookies/new players
            # Update TLFL team data
            # Update Player data
            # Update TeamDst data 

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

        def reset_protections
            TlflTeam.all.each do |team|
                team.update(protections: 3)
            end
        end

    # After Rosters are entered 
        def reset_player_available
            Player.all.each do |player|
                if player.tlfl_team_id == nil
                    player.update(available: true)
                else
                    player.update(available: false)
                end
            end
        end
    
    # Check all TLFL players have correct esb_id

    # Create ScheduleGames for new season
        
end
