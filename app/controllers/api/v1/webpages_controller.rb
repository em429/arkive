module Api
  module V1
    class WebpagesController < ApiController
    
      def create
        webpage = Webpage.new(webpage_params)
        
        # Save to database
        if webpage.save
          Thread.new do
            Rails.application.executor.wrap do
              # Save to Internet Archive
              uri = URI('https://web.archive.org/save')
              res = Net::HTTP.post_form(uri, :url => webpage.url, :capture_all => 'on')
              webpage.update(internet_archive_url: "https://web.archive.org/web/" + webpage.url)

              # Extract primary readable content and add it to db
              source = open(webpage.url).read
              webpage.update(content: Readability::Document.new(source).content)
            end
          end

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
