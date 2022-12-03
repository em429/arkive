module Archivers
  extend ActiveSupport::Concern

  private

  	def fetch_title(webpage)
    	title = Net::HTTP.get(URI(webpage.url)).scan(/<title>(.*?)<\/title>/)[0][0]
  	end

		def archive(webpage)
      Thread.new do
        Rails.application.executor.wrap do
          # Save to Internet Archive
          ia_api_uri = URI('https://web.archive.org/save')
          
          res = Net::HTTP.post_form(ia_api_uri, :url => webpage.url, :capture_all => 'on')
          webpage.update(internet_archive_url: "https://web.archive.org/web/" + webpage.url)

          # Extract primary readable content and add it to db
          source = open(webpage.url).read
          webpage.update(content: Readability::Document.new(
          	source,
          	:tags => %w[div p pre a tbody tr td h1 h2 h3 h4 h5 h6 img],
          	:remove_empty_nodes => true).content)
        end
      end
		end
end
