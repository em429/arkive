require "application_system_test_case"

Selenium::WebDriver::Chrome::Service.driver_path = Rails.root.join( "lib", "/nix/store/2rbx4idiw1l3m2bpj66dbcs6jfpgvm13-chromedriver-103.0.5060.24/bin/chromedriver" ).to_s

class WebpagesTest < ApplicationSystemTestCase
 setup do
  @webpage = webpages(:first) 
 end

	test "Showing an archived webpage" do
  	visit webpages_path
  	click_link @webpage.name

  	assert_selector "h1", text: @webpage.name
	end

	test "Adding a new webpage to the archive" do
  	visit webpages_path
  	assert_selector "h1", text: "Private Web Archive"

  	click_on "Add"
  	fill_in "Title", with: "Capybara Webpage"
  	fill_in "Url", with: "https://capybara.com"
  	
  	assert_selector "h1", text: "Private Web Archive"
  	click_on "Create Webpage"
  	
  	assert_selector "h1", text: "Private Web Archive"
  	assert_text "Capybara Webpage"
	end

	test "Updating an archived webpage" do
  	visit webpages_path
  	assert_selector "h1", text: "Private Web Archive"

  	click_on "EDIT", match: :first
  	assert_selector "h1", text: "Private Web Archive"
  	
  	fill_in "Title", with: "Updated Capybara Webpage"
  	click_on "Update Webpage"

  	assert_selector "h1", text: "Private Web Archive"
  	assert_text "Updated Webpage"
	end

	test "Destroying a Webpage" do
  	visit webpages_path
  	assert_text @webpage.name

  	click_on "DELETE", match: :first
  	assert_no_text @webpage.name
	end
end


