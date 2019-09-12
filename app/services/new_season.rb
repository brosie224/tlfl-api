class NewSeason

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
    # create_new_players (to add new players)
    # update_player_data
    # update_tlfl_team_bye

end
