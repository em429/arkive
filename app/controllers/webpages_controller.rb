class WebpagesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
    if logged_in?
      @webpages = current_user.webpages.where(read_status: false).ordered
    else
      redirect_to login_path
    end
  end

  def show_read
    @webpages = current_user.webpages.all.ordered
    render "index"
  end

  def show
    @webpage = Webpage.find(params[:id])
  end
  
  def new
    @webpage = Webpage.new
  end

  def create
    @webpage = current_user.webpages.build(webpage_params)
    
    if @webpage.title == ""
      # Set a temporary title until the real one is fetched
      @webpage.title = "Fetching title.."
      Thread.new do
        Rails.application.executor.wrap do
          # When title comes empty through the API, it's nil for some reason, not "" like here
          @webpage.title = fetch_title(@webpage)
        end
      end
    end

    # Save to database
    begin
      if @webpage.save
        archive(@webpage)
       
        respond_to do |format|
          format.html { redirect_to webpages_path, notice: "Successfully added to archive." }
          format.turbo_stream { flash.now[:notice] = "Successfully added to archive." }
        end
      else
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
        render :new_is_duplicate, status: :unprocessable_entity
    end
  end

  def edit
    @webpage = Webpage.find(params[:id])
  end

  def update
    @webpage = Webpage.find(params[:id])

    if @webpage.update(webpage_params)
      redirect_to @webpage, notice: "Webpage was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_read_status
    @webpage = Webpage.find(params[:id])
    
    if @webpage.read_status
      @webpage.update(read_status: false)
    else
      @webpage.update(read_status: true)
    end

    if request.referrer == request.base_url + "/"
      redirect_to root_path 
    elsif request.referrer == request.base_url + "/show_read"
      redirect_to show_read_path
    else
      redirect_to @webpage
    end
  end

  def destroy
    # @webpage = Webpage.find(params[:id])
    @webpage.destroy

    redirect_to root_path, status: :see_other, notice: "Webpage was successfully deleted."
  end

  private
  	def webpage_params
    	params.require(:webpage).permit(:title, :url, :internet_archive_url)
  	end
  	
    def correct_user
      @webpage = current_user.webpages.find_by(id: params[:id])
      redirect_to(root_url, status: :see_other) if @webpage.nil?
    end
end
