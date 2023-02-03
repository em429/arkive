class UsersController < ApplicationController
  # Don't require login for sign-up form:
  skip_before_action :require_login, only: %i[new create]

  # Users can only check their own profile and update it:
  before_action :require_correct_user, only: %i[show edit update]

  # Only admin users can list all users and delete them
  before_action :require_admin, only: %i[index destroy]

  ## Methods without need to fin existing @user
  #############################################
  
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id # automatically log-in user
        redirect_to root_path, notice: 'Zoe welcomes you to your private archive! Woof!'
      else
        render :new, status: :unprocessable_entity
      end
  end

  ## Methods that need to find existing @user
  ###########################################
  
  def show
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: 'Profile updated' }
        # format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User deleted' }
      # format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def require_correct_user
    set_user
    redirect_to(root_url) unless @user == current_user
  end

  def require_admin
    redirect_to(root_url) unless current_user.admin?
  end
end
