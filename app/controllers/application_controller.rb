class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Archivers
  include SessionsHelper
end
