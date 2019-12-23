class DraftPick < ApplicationRecord
    belongs_to :tlfl_team

    def full
        if overall
            "#{self.year} #{self.round.ordinalize}-round pick (##{self.overall})"
        else
            "#{self.year} #{self.round.ordinalize}-round pick (#{self.team})"
        end
    end
    
end