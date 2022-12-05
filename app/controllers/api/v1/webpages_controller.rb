module Api
  module V1
    class WebpagesController < ApiController
      def create
        # If no webpage params present, render friendly error:
        if params[:webpage].nil?
          render json: { status: 'error', message: 'You must provide at least an URL!' }, status: :unprocessable_entity
          return
        end

        webpage = current_user.webpages.build(webpage_params)

        if webpage.save
          render json: { status: 'success', message: 'Webpage archived successfully!' }, status: :created
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
