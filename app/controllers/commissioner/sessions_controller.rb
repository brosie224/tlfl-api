module Commissioner
  class SessionsController < ApplicationController

    def new
    end
    
    def create
        @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          redirect_to commissioner_path
        else
          flash.now.alert = "Incorrect email or password."
          render :new
        end
    end
  
    def destroy
      reset_session
      redirect_to commissioner_login_path
    end
  
  end
end