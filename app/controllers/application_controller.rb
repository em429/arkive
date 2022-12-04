class ApplicationController < ActionController::Base
  include Archivers
  include SessionsHelper

  # TODO: check what the below line does
  protect_from_forgery with: :exception

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
