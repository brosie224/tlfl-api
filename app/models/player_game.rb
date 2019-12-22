class PlayerGame < ApplicationRecord
    include PlayerPts
    belongs_to :player
end
