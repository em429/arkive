class WebpagesController < ApplicationController
  # Check every time if user is trying to view their own webpage
  # The index/show_all/create/new action has no id, so there we skip it.
  #    The index/show_all is already rendered from only the current user's stuff.
  #    And create will only allow creating for current user, of course.
  before_action :check_user_owns_page, except: %i[index show_read create new]

  def index
    @webpages = current_user.webpages.where(read_status: false).ordered
  end

  def show_read
    @webpages = current_user.webpages.all.ordered
    render 'index'
  end

  def show
    @webpage = Webpage.find_by(url_md5_hash: params[:url_md5_hash])
  end

  def new
    @webpage = Webpage.new
  end

  def create
    @webpage = current_user.webpages.build(webpage_params)

    # Save to database
    begin
      if @webpage.save
        FetchPageDataJob.perform_later(@webpage, from_archive=false)
        SubmitToInternetArchiveJob.perform_later(@webpage)
        
        respond_to do |format|
          notice = 'Successfully added to archive'
          format.turbo_stream { flash[:now] = notice }
          format.html { redirect_to webpage_path(@webpage), notice: notice }
        end
        
      else
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      render :new_is_duplicate, status: :unprocessable_entity
    end
  end

  def edit
    @webpage = Webpage.find_by(url_md5_hash: params[:url_md5_hash])
  end

  def update
    @webpage = Webpage.find_by(url_md5_hash: params[:url_md5_hash])

    if @webpage.update(webpage_params)
      redirect_to @webpage, notice: 'Webpage was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # FIXME lol
  def toggle_read_status
    @webpage = Webpage.find_by(url_md5_hash: params[:url_md5_hash])

    if @webpage.read_status
      @webpage.update(read_status: false)
    else
      @webpage.update(read_status: true)
    end

    # FIXME Uhhhhhhhhh.. :')
    case request.referer
    when "#{request.base_url}/"
      redirect_to root_path
    when "#{request.base_url}/webpages/show_read"
      redirect_to show_read_webpages_path
    else
      redirect_to @webpage
    end
  end

  def destroy
    # @webpage = Webpage.find(params[:id])
    @webpage.destroy

    redirect_to root_path, status: :see_other, notice: 'Webpage was successfully deleted.'
  end

  private

  def webpage_params
    params.require(:webpage).permit(:title, :url, :internet_archive_url)
  end

  def check_user_owns_page
    @webpage = current_user.webpages.find_by(url_md5_hash: params[:url_md5_hash])
    redirect_to(root_url, status: :see_other) if @webpage.nil?
  end
end
