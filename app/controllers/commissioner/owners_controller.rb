module Commissioner
    class OwnersController < ApplicationController
  
        def assign
            @owners = Owner.order(:last_name, :first_name).where(tlfl_team: nil)
        end

        def add
            params[:assign].each do |owner_id|
                owner = Owner.find(owner_id)
                owner.tlfl_team_id = params[:tlfl_team][:id]
                owner.save
            end
            redirect_to commissioner_assign_path
        end
    
    end
end