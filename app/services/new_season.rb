class NewSeason

    # Offseason
        # Assign overall to each DraftPick
            # create new array of picks (eg [{team: Saints, round: 1, overall, 32}, {team: Saints, round: 2, overall, 64}] ) 
            # DraftPick.all.each do, new.each do00
                # if pick.team == new.team && pick.round == new.round then pick.overall = new.overall

    def generate_draft_picks(year)
        DraftPick.destroy_all
        TlflTeam.all.each do |tm|
            for rd in 1..6 do
                tm.draft_picks.build(team: tm.full_name, year: year, round: rd)
                tm.save
            end
        end
    end

    def set_keepers # put in players controller?
    end

    # FdService methods to run:
        # create_new_players (to add rookies/new players)
        # update_tlfl_team_data
        # update_player_data
        # update_teams_dst_data

end
