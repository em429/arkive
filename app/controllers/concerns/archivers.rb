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

          # Extract primary readable content and add it to db
          # 
          # TODO: try replacing with webpage.internet_archive_url ?
          source = open(webpage.internet_archive_url).read
          content = Readability::Document.new(
          	source,
          	:tags => %w[div header h1 h2 h3 h4 h5 h6 h7 p a pre img strong blockquote i b ul li],
          	:remove_empty_nodes => true,
          	:attributes => %w[href],
          	:debug => true,
          	:min_image_height => 200,
          	:min_image_width => 200,
          	:ignore_image_format => ["gif", "png"]
          	).content

          # Fix relative links in extracted content:
          # Regex below matches all strings starting with '/web/' and inserts IA's url in front
          # TODO: fix the relative link fixing
          content_with_fixed_links = content.gsub(%r{^/web/}, 'https://web.archive.org')
          webpage.update(content: content_with_fixed_links)
        end
      end
		end
end
