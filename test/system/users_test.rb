require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:john)
  end

  test "should let successful signup" do
    visit root_url
    click_on 'Sign up now!'
    fill_in 'Username', with: 'test'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: 'asdf1234'
    fill_in 'Confirm password', with: 'asdf1234'
    click_on 'Create User'
    assert_equal 'Zoe welcomes you to your private archive! Woof!', flash[:notice]
    
  end

  # test 'cannot list users' do
  #   visit users_url
  #   capybara_log_in_as(@user)
  #   # assert_response :not_found
  # end

  test 'should update User' do
    visit user_url(@user)
    capybara_log_in_as(@user)
    
    # click_on 'Edit this user', match: :first

    # fill_in 'Email', with: @user.email
    # fill_in 'Name', with: @user.username
    # click_on 'Update User'

    # assert_text 'User was successfully updated'
    # click_on 'Back'
  end

  test 'should destroy User' do
    visit user_url(@user)
    click_on 'Destroy this user', match: :first

    assert_text 'User was successfully destroyed'
  end
end
