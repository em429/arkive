require 'test_helper'

class WebpagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get webpages_index_url
    assert_response :success
  end
end
