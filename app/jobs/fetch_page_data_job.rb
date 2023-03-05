require 'uri_utils'

class FetchPageDataJob < ApplicationJob
  queue_as :default
  
  def perform(webpage, from_archive: false)
    webpage.update(
      content: fetch_readable_content(webpage.url, from_archive: from_archive),
      title: fetch_title(webpage.url)
    )
  end
  
end
