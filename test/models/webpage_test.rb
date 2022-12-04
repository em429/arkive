require 'test_helper'

class WebpageTest < ActiveSupport::TestCase
  test 'should not save webpage without url' do
    webpage = Webpage.new
    assert_not webpage.save, 'Saved webpage without url'
  end

  test 'should save webpage with url and user_id only' do
    webpage = Webpage.new
    webpage.user_id = 1
    webpage.url = 'https://lobste.rs'
    assert webpage.save, "Couldn't save webpage with URL and user_id only"
  end
end
