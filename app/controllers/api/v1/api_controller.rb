module Api
  module V1
    class ApiController < ActionController::Base
      include Archivers

      before_action :check_basic_auth
      skip_before_action :verify_authenticity_token

      private

      def check_basic_auth
        if request.authorization.blank?
          head :unauthorized
          return
        end
        authenticate_with_http_basic do |email, password|
          user = User.find_by(email: email.downcase)
          if user&.authenticate(password)
            @current_user = user
          else
            head :unauthorized
          end
        end
      end

      attr_reader :current_user
    end
  end
end
