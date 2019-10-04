class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def admin_required
    if !current_user 
      flash[:alert] = "You must be an admin to perform this action."
      redirect_to commissioner_login_path
    elsif current_user.email != "barosengarten@gmail.com"
      flash[:alert] = "You must be an admin to perform this action."
      redirect_to commissioner_login_path
    end
  end

  def commissioner_required
    commissioners = ["barosengarten@gmail.com"]
    if !current_user 
      flash[:alert] = "You must be a commissioner to perform this action."
      redirect_to commissioner_login_path
    elsif !commissioners.include? current_user.email
      flash[:alert] = "You must be a commissioner to perform this action."
      redirect_to commissioner_login_path
    end
  end
      
end