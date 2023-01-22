class FetchTitleJob < ApplicationJob
  queue_as :default

  def perform(webpage)
    title = Net::HTTP.get(URI(webpage.url)).scan(%r{<title>(.*?)</title>})[0][0].force_encoding('UTF-8')
    webpage.update(title: title)
  rescue StandardError => e
    Rails.logger.warn "Error while fetching title: #{e}"
    # TODO: implement Kaya's equation to generate a title without request
  end
end
