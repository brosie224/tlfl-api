class ApplicationController < ActionController::Base
    protect_from_forgery
  
    helper_method :current_user
  
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  
    # def admin_required
    #   if !current_user 
    #     flash.now.alert = "You must be an admin to perform this action."
    #     redirect_to commissioner_login_path
    #     return
    #   end
    #   if current_user.email != "barosengarten@gmail.com"
    #     flash.now.alert = "You must be an admin to perform this action."
    #     redirect_to commissioner_login_path
    #   end
    # end
  
    def commissioner_required
      if !current_user 
        flash.now.alert = "You must be a commissioner to perform this action."
        redirect_to commissioner_login_path
        return
      end
      commissioners = ["barosengarten@gmail.com"]
      if !commissioners.include? current_user.email
        flash.now.alert = "You must be a commissioner to perform this action."
        redirect_to commissioner_login_path
      end
    end
      
  end