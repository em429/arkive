require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test "should not let empty signup" do
    visit new_user_url
    click_on 'Create User'
    assert page.has_content? "Username can't be blank"
    assert page.has_content? "Email can't be blank"
    assert page.has_content? "Email is invalid"
    assert page.has_content? "Password must be 8+ characters, and must include at least a number."
  end

  test "should let valid signup" do
    visit root_url
    click_on 'Sign up now!'
    fill_in 'Username', with: 'test'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: 'asdf1234'
    fill_in 'Confirm password', with: 'asdf1234'
    click_on 'Create User'
    assert page.has_content? 'Private Web Archive'
  end

  test 'regular user cannot list users' do
    visit users_url
    capybara_log_in_as(@user)
    assert page.has_content? 'Private Web Archive'
  end

  test 'should update User' do
    visit user_url(@user)
    capybara_log_in_as(@user)
    
    click_link "Edit"
    fill_in 'Email', with: "test@test.com"
    fill_in 'Password', with: @user.password
    fill_in 'Confirm password', with: @user.password
    click_button "Update User"
    
    assert page.has_content? 'test@test.com'
    
  end

end
