class WebpageStatusesController < ApplicationController
  def update
    @webpage = Webpage.find(params[:id])

    if @webpage.status_read?
      @webpage.status_unread!
    else
      @webpage.status_read!
    end

    redirect_to request.referrer
  end
end
