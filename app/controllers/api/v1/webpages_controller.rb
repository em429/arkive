module Api
  module V1
    class WebpagesController < ApiController
    
      def create
        webpage = Webpage.new(webpage_params)
        # For some reason, if title is empty through API it becomes `nil`, if it's empty
        # through the UI, it becomes "" ...
        if webpage.title == nil
          webpage.title = fetch_title(webpage)
        end
        
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
