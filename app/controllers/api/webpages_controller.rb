class Api::WebpagesController < ApiController
  include ApiResponders
    
  skip_forgery_protection
  skip_before_action :require_login

  def create
    @user = User.find(1)
    @webpage = @user.webpages.build(webpage_params)

    # Save to database
    if @webpage.save
      FetchPageDataJob.perform_later(@webpage)
      SubmitToInternetArchiveJob.perform_later(@webpage)

      respond_with_success("Webpage succesfully added to Arkive!",
        context: { webpage: @webpage.as_json })
      
    else
      respond_with_error("Couldn't add webpage to Arkive")
    end
  end

  private

  def webpage_params
    params.require(:webpage).permit(:title, :url, :internet_archive_url)
  end
  
end
