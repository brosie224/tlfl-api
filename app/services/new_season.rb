class NewSeason

    # Do global search for last year (ie 2019) and change to current year

    # Organize everything by order of when run; Group together based on order

    # Offseason

    # Before TLFL Draft
    
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

        # To-Do List w/ corresponding methods:
            # Add rookies/new players
            # Update TLFL team data
            # Update Player data
            # Update TeamDst data 
            # New Schedule

    # After TLFL Draft

        def generate_draft_picks
            DraftPick.destroy_all
            TlflTeam.all.each do |tlfl_team|
                for rd in 1..6 do
                    tlfl_team.draft_picks.build(team: tlfl_team.full_name, year: Date.today.year + 1, round: rd)
                    tlfl_team.save
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
                player.tlfl_team_id == nil ? player.update(available: true) : player.update(available: false)
            end
        end
    
    # Check all TLFL players have correct esb_id

    # Create ScheduleGames for new season
        
end
