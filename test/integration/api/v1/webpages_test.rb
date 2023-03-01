require 'test_helper'

class Api::V1::WebpagesTest < ActionDispatch::IntegrationTest
  test "post a webpage" do
    post api_v1_webpages_path()
  end
end
