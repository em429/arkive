module Api
  module V1
    class WebpagesController < ApiController
    
      def create
        # If no webpage params present, render friendly error:
        if params[:webpage].nil?
          render json: { status: "error", message: "You must provide at least an URL!" }, status: :unprocessable_entity
          return
        end
        
        webpage = Webpage.new(webpage_params)
        
        # For some reason, if title is empty through API it becomes `nil`, if it's empty
        # through the UI, it becomes "" ...
        if webpage.title == nil
          webpage.title = fetch_title(webpage)
        end

        # set owner user to the one requesting
        webpage.user_id = current_user.id
        
        if webpage.save
          archive(webpage)
          render json: { status: "success", message: "Webpage archived successfully!" }, status: :created
        else
          render json: webpage.errors, status: :unprocessable_entity         
        end
      end

      private
      	def webpage_params
          params.require(:webpage).permit(:title, :url, :internet_archive_url)
        end
        
    end
  end
end
