class DraftPick < ApplicationRecord
    belongs_to :tlfl_team

    def full
        if self.overall == nil
            "#{self.year} #{self.round.ordinalize}-round pick (#{self.team})"
        else
            "#{self.year} #{self.round.ordinalize}-round pick (##{self.overall})"
        end
    end
    
end