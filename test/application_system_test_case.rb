require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def capybara_log_in_as(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button "Log in"
  end
  
end


