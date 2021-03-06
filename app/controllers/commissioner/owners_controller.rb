module Commissioner
    class OwnersController < ApplicationController
        before_action :commissioner_required
  
        # Add a create and edit for Scott/Seth

        def assign
            @owners = Owner.order(:last_name, :first_name).where(tlfl_team: nil)
        end

        def add
            params[:owner].each do |owner_id|
                owner = Owner.find_by(id: owner_id)
                owner.tlfl_team_id = params[:tlfl_team_owners][:id]
                owner.save
            end
            redirect_to commissioner_assign_path
        end
    
    end
end