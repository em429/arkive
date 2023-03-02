class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :null_session
  before_action :require_login

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    user == current_user
  end
  
  def require_login
    store_location
    redirect_to new_session_path, alert: "Log-in required" unless current_user
  end

  helper_method :current_user
  helper_method :current_user?
  
end
