class Api::V1::WebpagesController < ApiController
  include ApiResponders

  def create
    # @user defined in ApiController.require_basic_auth
    @webpage = @user.webpages.build(webpage_params)

    # Save to database
    if @webpage.save
      FetchPageDataJob.perform_later(@webpage)
      SubmitToInternetArchiveJob.perform_later(@webpage)

      respond_with_success("Webpage succesfully added to Arkive!",
        context: { webpage: @webpage.as_json })
      
    else
      respond_with_error(@webpage.errors)
    end
  end

  private

  def webpage_params
    params.require(:webpage).permit(:title, :url, :internet_archive_url)
  end
  
end
