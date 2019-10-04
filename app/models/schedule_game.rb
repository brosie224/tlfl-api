class ScheduleGame < ApplicationRecord

    def self.weekly(week)
        self.where(week: week)
    end 

end
