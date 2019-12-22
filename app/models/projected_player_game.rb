class ProjectedPlayerGame < ApplicationRecord
    include PlayerPts
    belongs_to :player
end
