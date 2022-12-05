require 'test_helper'

class WebpagesInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'webpage interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div nav'
    # assert_select 'div.pagination'

    # Invalid submission
    assert_no_difference 'Webpage.count' do
      post webpages_path, params: { webpage: { url: '' } }
    end
    assert_select 'div#error_explanation'
    # assert_select 'a[href=?]', '/?page=2'  # Correct pagination link

    # Valid submission
    url = 'Test archive'
    assert_difference 'Webpage.count', 1 do
      post webpages_path, params: { webpage: { url: 'https://lobste.rs' } }
    end

    # Duplicate submission
    url = 'Test 2 archive'
    assert_no_difference 'Webpage.count' do
      post webpages_path, params: { webpage: { url: 'https://lobste.rs' } }
    end
    assert_select 'div#error_explanation'

    # assert_redirected_to root_url
    # follow_redirect!
    # assert_match content, response.body
    #
    # # Delete post.
    # assert_select 'a', text: 'delete'
    # first_webpage = @user.webpages.paginate(page: 1).first
    # assert_difference 'Webpage.count', -1 do
    #   delete webpage_path(first_webpage)
    # end

    # Visit different user (no delete links).
    # get user_path(users(:archer))
    # assert_select 'a', { text: 'delete', count: 0 }
  end
end
