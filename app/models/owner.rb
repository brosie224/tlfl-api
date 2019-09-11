class Owner < ApplicationRecord
    belongs_to :tlfl_team

    def full_name
        self.first_name + " " + self.last_name
    end
    
end
