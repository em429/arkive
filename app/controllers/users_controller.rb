class UsersController < ApplicationController
  # Don't require login for sign-up form:
  skip_before_action :require_login, only: %i[new create]

  # Users can only check their own profile and update it:
  before_action :correct_user, only: %i[show edit update]

  # Only admin users can list all users and delete them
  before_action :admin_user, only: %i[index destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.friendly.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to root_path, notice: 'Zoe welcomes you to your private archive! Woof!' }
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.friendly.find(params[:id])
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user = User.friendly.find(params[:id])
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

  # DELETE /users/1 or /users/1.json
  def destroy
    User.friendly.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User deleted' }
      # format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms the correct user.
  def correct_user
    @user = User.friendly.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
