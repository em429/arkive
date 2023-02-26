require 'test_helper'

class WebpageTest < ActiveSupport::TestCase
  def setup
    @user = users(:mary)
    @webpage = @user.webpages.build(title: "Hey it's a title!",
                                    url: 'https://lobste.rs')
  end

  test 'should be valid' do
    assert @webpage.valid?
  end

  test 'user id should be present' do
    @webpage.user_id = nil
    assert_not @webpage.valid?
  end

  test 'url should be present' do
    @webpage.url = '   '
    assert_not @webpage.valid?
  end
end
