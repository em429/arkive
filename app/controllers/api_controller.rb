class ApiController < ApplicationController
  skip_forgery_protection
  skip_before_action :require_login

  before_action :require_basic_auth
  before_action :require_json

  private 

  def require_basic_auth
    authenticate_or_request_with_http_basic do |email, password|
      @user = User.find_by(email: email)
      true if @user && @user.authenticate(password)
    end
  end 

  def require_json
    head 406 unless request.format.json?
  end
end