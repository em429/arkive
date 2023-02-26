class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    redirect_to root_path if current_user
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to (session[:intended_url] || user), notice: "Welcome back, #{user.username}!"
      session[:intended_url] = nil
    else
      flash.now[:alert] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, status: :see_other, notice: "Logged out"
  end

  private
  
end
