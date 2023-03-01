require 'test_helper'

class WebpageTest < ActiveSupport::TestCase
  def setup
    @webpage = FactoryBot.create(:webpage)
  end

  test 'should be valid' do
    assert @webpage.valid?
  end

  test 'should be valid without title' do
    assert FactoryBot.create(:webpage, :without_title).valid?
  end

  test 'user id should be present' do
    @webpage.user_id = nil
    assert_not @webpage.valid?
  end

  test 'url should be present' do
    @webpage.url = '   '
    assert_not @webpage.valid?
  end

  test 'url valid with protocol' do
    @webpage.url = 'http://example.com'
    assert @webpage.valid?

    @webpage.url = 'https://example.com'
    assert @webpage.valid?
  end

  test 'url valid without protocol' do
    @webpage.url = 'example.com'
    assert @webpage.valid?

    @webpage.url = 'example.cool'
    assert @webpage.valid?
  end

  test 'default status is unread' do
    assert @webpage.status_unread?
  end

  test 'read status is valid initially too' do
    @read_webpage = FactoryBot.create(:webpage, :read)
    assert @read_webpage.valid?
    assert @read_webpage.status_read?
  end

  test 'can set status' do
    @webpage.status = :started
    assert @webpage.status_started?

    @webpage.status = :unread
    assert @webpage.status_unread?

    @webpage.status = :read
    assert @webpage.status_read?
  end

end
