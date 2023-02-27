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
    visit user_url(@user.username)
    
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'asdf1234'
    click_button "Log in"
    
    assert page.has_content? 'Private Web Archive'
    
  end

end
