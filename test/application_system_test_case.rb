require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def capybara_log_in_as(user, password: 'asdf1234')
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button "Log in"
    # magic_test
    assert page.has_content? 'Private Web Archive'
  end
  
end


