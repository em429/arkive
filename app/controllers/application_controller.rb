class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :null_session
  before_action :require_login

  private
  
  # Confirms a logged-in user.
  def require_login
    return if logged_in?
    
    # Otherwise flash an error message:
    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url, status: :see_other
  end
end
