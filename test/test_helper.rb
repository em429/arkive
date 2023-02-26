ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def logged_in?
    !session[:user_id].nil?
  end
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'asdf1234')
    post session_url(email: user.email, password: password)
    assert_equal "Welcome back, #{user.username}!", flash[:notice]
  end
end
