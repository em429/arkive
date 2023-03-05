require 'application_system_test_case'

# TODO assert flash notices happen too
class WebpagesTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
    @webpage = FactoryBot.create(:webpage, user: @user)
  end

  test 'should not show webpage without login' do
    visit user_webpage_path(@user, @webpage)
    assert_text 'Log-in required'
  end

  test 'should not show other users webpage' do

    @other_user = FactoryBot.create(:user)
    @other_webpage = FactoryBot.create(:webpage, user: @other_user)
    visit user_webpage_path(@other_user, @other_webpage)
    capybara_log_in_as(@user)

    assert_no_text @other_webpage.title
    assert_text 'Private Web Archive'

  end

  test 'Showing an archived webpage' do
    visit user_webpages_path(@user)
    capybara_log_in_as(@user)
    assert_selector 'h1', text: 'Private Web Archive'
    click_link @webpage.title

    assert_selector 'h1', text: @webpage.title
  end

  test 'Adding a new webpage to the archive' do
    visit user_webpages_path(@user)
    capybara_log_in_as(@user)
    url = Faker::Internet.url
    title = Faker::Book.title

    click_on 'Add'
    fill_in 'Title', with: title
    fill_in 'URL', with: url
    find('form #webpage_url').native.send_keys :enter
    assert page.has_content? title
  end

  test 'Updating an archived webpage' do
    visit user_webpage_path(@user, @webpage)
    capybara_log_in_as(@user)
    click_on 'Edit'
    title = Faker::Book.title

    fill_in 'Title', with: title
    find('form #webpage_url').native.send_keys :enter
    assert page.has_content? title
  end

  test 'Destroying a Webpage' do
    visit user_webpage_path(@user, @webpage)
    capybara_log_in_as(@user)
    assert_text @webpage.title

    accept_alert do
      click_on 'Delete', match: :first
    end

    assert_no_text @webpage.title
  end
end
