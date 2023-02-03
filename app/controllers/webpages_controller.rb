class WebpagesController < ApplicationController
  # Check every time if user is trying to view their own webpage
  # The index/create/new action we skip the check (it would also fail bc. no id)
  #    The index/show_all is already rendered from only the current user's stuff
  #    And create will only allow creating for current user
  before_action :check_user_owns_page, except: %i[index create new]

  before_action :set_webpage,
    only: %i[show edit update destroy mark_read mark_unread]

  ## Methods without need to find existing @webpage
  #################################################
  def index
    case params[:filter]
    when 'unread'
      @webpages = current_user.webpages.unread
    when 'read'
      @webpages = current_user.webpages.read
    when 'all'
      @webpages = current_user.webpages.ordered
    else # show unread only by default
      @webpages = current_user.webpages.unread
    end
  end

  def new
    @webpage = current_user.webpages.new
  end

  def create
    @webpage = current_user.webpages.build(webpage_params)

    # Save to database
    if @webpage.save
      FetchPageDataJob.perform_later(@webpage, from_archive=false)
      SubmitToInternetArchiveJob.perform_later(@webpage)
      
      respond_to do |format|
        notice = 'Successfully added to archive'
        # NOTE: temporarily disabled until I figure out a way to update the title
        # once it is fetched.
        # format.turbo_stream { flash[:now] = notice }
        format.html { redirect_to webpage_path(@webpage), notice: notice }
      end
      
    else
      render :new, status: :unprocessable_entity
    end
  end

  ## Methods that need to set @webpage:
  #####################################
  def show
  end

  def edit
  end

  def update
    if @webpage.update(webpage_params)
      redirect_to webpage_path(@webpage), notice: 'Webpage was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @webpage.destroy

    redirect_to root_path, status: :see_other, notice: 'Webpage was successfully deleted.'
  end

  def mark_read
    @webpage.update!(read_status: true)
    redirect_to request.referrer
  end
  
  def mark_unread
    @webpage.update!(read_status: false)
    redirect_to request.referrer
  end

  ## Private methods
  ##################
  private

  def set_webpage
    @webpage = Webpage.find_by(url_md5_hash: params[:url_md5_hash])
  end

  def webpage_params
    params.require(:webpage).permit(:title, :url, :internet_archive_url)
  end

  def check_user_owns_page
    @webpage = current_user.webpages.find_by(url_md5_hash: params[:url_md5_hash])
    redirect_to(root_url, status: :see_other) if @webpage.nil?
  end
end
