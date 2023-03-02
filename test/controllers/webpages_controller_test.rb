require 'test_helper'

class WebpagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin_user)
    @webpage = FactoryBot.create(:webpage, user: @user)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Webpage.count' do
      post user_webpages_path(@user), params: { webpage: { url: 'https://mrem.ml' } }
    end
    assert_redirected_to new_session_url
  end

  test 'can create when logged in' do
    log_in_as(@user)
    assert_difference 'Webpage.count', 1 do
      post user_webpages_path(@user),
        params: { webpage: { url: 'http://success.example.test' } }
    end
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Webpage.count' do
      delete user_webpage_path(@user, @webpage)
    end
    # assert_response :see_other
    assert_redirected_to new_session_url
  end

  test 'should redirect destroy for wrong webpage' do
    log_in_as(@user)

    @webpage2 = FactoryBot.create(:webpage, user: @admin)

    assert_no_difference 'Webpage.count' do
       delete user_webpage_path(@admin, @webpage2)
    end

    assert_response :see_other
    assert_redirected_to root_url
  end

  test 'should be able to destroy own webpage' do
    log_in_as(@user)
    ownpage = FactoryBot.create(:webpage, user: @user)
    assert_difference 'Webpage.count', -1 do
      delete user_webpage_path(@user, ownpage)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

  test 'duplicate submission is invalid' do
    log_in_as(@user)

    post user_webpages_path(@user),
      params: { webpage: { url: 'http://example.test' } }

    assert_no_difference 'Webpage.count' do
      post user_webpages_path(@user),
        params: { webpage: { url: 'http://example.test' } }
    end

    assert_select 'div#error_explanation'
  end

  # test 'admin should be able to destroy any webpage' do
  #   log_in_as(@admin)
  #   assert_difference 'Webpage.count', -1 do
  #     delete user_webpage_path(@user, @webpage)
  #   end
  # end

  # test 'only admin can see user list' do
  # end

end
