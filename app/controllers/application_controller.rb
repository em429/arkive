class ApplicationController < ActionController::Base
  include Archivers
  include SessionsHelper

  # TODO: check what the below line does
  protect_from_forgery with: :exception

  before_action :require_login
 
  private
    # Confirms a logged-in user.
    def require_login
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end  
end
