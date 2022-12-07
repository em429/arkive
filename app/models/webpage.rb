class Webpage < ApplicationRecord
  belongs_to :user
  validates :url, presence: true, url: true,
                  uniqueness: { scope: :user_id, message: 'Webpage already in archive' }
  validates :user_id, presence: true
  scope :ordered, -> { order(id: :desc) }

  after_create_commit :fetch_title, if: :title_missing?
  after_create_commit :submit_to_internet_archive

  def reading_time
    words_per_minute = 230
    begin
      text = Nokogiri::HTML(content).at('body').inner_text
      (text.scan(/\w+/).length / words_per_minute).to_i
    rescue NoMethodError
      '?'
    end
  end

  private

  def title_missing?
    title.blank?
  end

  def fetch_title
    Thread.new do
      Rails.application.executor.wrap do
        self.title = Net::HTTP.get(URI(url)).scan(%r{<title>(.*?)</title>})[0][0]
      end
    end
  end

  def submit_to_internet_archive
    Thread.new do
      Rails.application.executor.wrap do
        source_url = URI.parse(url)
        # Save to Internet Archive
        ia_api_uri = URI('https://web.archive.org/save')
        res = Net::HTTP.post_form(ia_api_uri, url: source_url, capture_all: 'on')
        raise 'ArchiveFailedException' if res.nil?

        # TODO: how to recover if response times out or errors?
        #       - put into retry queue that gets retried every 10m?
        #       - simply warn user w red title?

        # Extract primary readable content and add it to db
        # source = URI.parse("https://web.archive.org/web/#{source_url}").open.read
        source = source_url.open.read

        readable_content = Readability::Document.new(
          source,
          tags: %w[div header h1 h2 h3 h4 h5 h6 h7 p a pre img strong blockquote i b ul li],
          remove_empty_nodes: true,
          attributes: %w[href],
          debug: true,
          min_image_height: 200,
          min_image_width: 200,
          ignore_image_format: %w[gif png]
        ).content

        # Fix relative links in extracted content:
        content_with_fixed_links = Nokogiri::HTML(readable_content)

        # find things using 'src' and 'href' parameters
        tags = {
          'img' => 'src',
          'a' => 'href'
        }

        # Search through the DOM for <img> and <a> tags, detect relative links
        # and replace them
        content_with_fixed_links.search(tags.keys.join(',')).each do |node|
          url_param = tags[node.name]

          # Skip if src attr is empty
          src = node[url_param]
          next if src.blank?

          uri = Addressable::URI.parse(src).normalize
          next if uri.absolute?

          uri.host = source_url.host
          uri.scheme = source_url.scheme
          node[url_param] = uri.to_s
          # If any of the URLs invalid, log it, leave them as is and continue
          rescue StandardError => e
            Rails.logger.warn "Error while parsing content URL during relative to absolute conversion: #{e}"
            next
        end

        # update table with contents
        update(content: content_with_fixed_links)
        
        rescue StandardError => e
          Rails.logger.warn "Error while submitting to internet archive: #{e}"
          # Write 'error' into content column, so we can tell between fetching and failed states
          update(content: "error")
          
        end
      end
    end
    
end
