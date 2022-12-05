require 'test_helper'

class WebpagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @webpage = webpages(:three)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Webpage.count' do
      post webpages_path, params: { webpage: { url: 'https://mrem.ml' } }
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Webpage.count' do
      delete webpage_path(@webpage)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test 'should redirect destroy for wrong webpage' do
    log_in_as(users(:archer))
    webpage = webpages(:two)
    assert_no_difference 'Webpage.count' do
      delete webpage_path(webpage)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

  test 'should be able to destroy own webpage' do
    log_in_as(users(:archer))
    webpage = webpages(:three)
    assert_difference 'Webpage.count', -1 do
      delete webpage_path(webpage)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

  test 'admin should be able to destroy any webpage' do
    log_in_as(users(:admin))
    webpage = webpages(:two)
    assert_difference 'Webpage.count', -1 do
      delete webpage_path(webpage)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
