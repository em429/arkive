require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = FactoryBot.create(:admin_user)

    @user = FactoryBot.create(:user)
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to new_session_url
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@admin)
    assert_not flash.empty?
    assert_redirected_to new_session_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@admin), params: { user: { username: @admin.username,
                                                    email: @admin.email } }
    assert_not flash.empty?
    assert_redirected_to new_session_url
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@user)
    get edit_user_path(@admin)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
     log_in_as(@user)
     patch user_path(@admin), params: { user: { username: @admin.username,
                                                     email: @admin.email } }
     assert_not flash.empty?
     assert_redirected_to root_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to new_session_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to root_url
  end
end
