class WebpagesController < ApplicationController
  # Check every time if user is trying to view their own webpage
  # The index/show_all/create/new action has no id, so there we skip it.
  #    The index/show_all is already rendered from onlu the current user's stuff.
  #    And create will only allow creating for current user, of course
  before_action :correct_user, except: %i[index show_read create new]

  def index
    @webpages = current_user.webpages.where(read_status: false).ordered
  end

  def show_read
    @webpages = current_user.webpages.all.ordered
    render 'index'
  end

  def show
    @webpage = Webpage.find(params[:id])
  end

  def new
    @webpage = Webpage.new
  end

  def create
    @webpage = current_user.webpages.build(webpage_params)

    # Save to database
    begin
      if @webpage.save
        FetchTitleJob.perform_later(@webpage) if @webpage.title_missing?
        SubmitToInternetArchiveJob.perform_later(@webpage)
        FetchReadableContentJob.perform_later(@webpage, from_archive=false)

        respond_to do |format|
          format.html { redirect_to webpages_path, notice: 'Successfully added to archive.' }
          format.turbo_stream { flash.now[:notice] = 'Successfully added to archive.' }
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
      redirect_to @webpage, notice: 'Webpage was successfully updated.'
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

  def correct_user
    @webpage = current_user.webpages.find_by(id: params[:id])
    redirect_to(root_url, status: :see_other) if @webpage.nil?
  end
end
