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

end
