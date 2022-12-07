class Webpage < ApplicationRecord
  belongs_to :user
  validates :url, presence: true, url: true,
                  uniqueness: { scope: :user_id, message: 'Webpage already in archive' }
  validates :user_id, presence: true
  scope :ordered, -> { order(id: :desc) }

  after_create_commit :fetch_title, if: :title_missing?
  after_create_commit :submit_to_internet_archive
  after_create_commit -> { fetch_readable_content(from_archive: true) }

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

  IA_API_URI = URI('https://web.archive.org/save')

  def title_missing?
    title.blank?
  end

  def fetch_title
    Thread.new do
      Rails.application.executor.wrap do
        self.title = Net::HTTP.get(URI(url)).scan(%r{<title>(.*?)</title>})[0][0]
      rescue StandardError => e
        Rails.logger.warn "Error while fetching title: #{e}"
        # TODO: implement Kaya's equation to generate a title without request
        #
      end
    end
  end

  # Fix relative links in extracted content:
  # Search through the DOM for <img> and <a> tags, detect relative links
  # and replace them
  def relative_to_absolute(base_url, target_dom)
    target_dom = Nokogiri::HTML(target_dom)
    # find things using 'src' and 'href' parameters
    tags = {
      'img' => 'src',
      'a' => 'href'
    }

    target_dom.search(tags.keys.join(',')).each do |node|
      url_param = tags[node.name]

      # Skip if src attr is empty
      src = node[url_param]
      next if src.blank?

      uri = Addressable::URI.parse(src).normalize
      next if uri.absolute?

      ia_uri = Addressable::URI.join(base_url, uri.path)
      node[url_param] = ia_uri.to_s

      # If any of the URLs invalid, log it, leave them as is and continue
    rescue StandardError => e
      Rails.logger.warn "Error while parsing content URL during relative to absolute conversion: #{e}"
      next
    end
    return target_dom
  end

  # Extract primary readable content and add it to db
  def fetch_readable_content(from_archive: false)
    Thread.new do
      Rails.application.executor.wrap do
        source_uri = Addressable::URI.parse(url)
        if from_archive
          source = URI.open(Addressable::URI.parse("https://web.archive.org/web/#{source_uri}")).read
          base_uri = 'https://web.archive.org/web/'
        else
          source = URI.open(source_uri).read
          base_uri = source_uri.site
        end

        readable_content = Readability::Document.new(
          source,
          tags: %w[div h1 h2 h3 h4 h5 h6 h7 p a pre img figure strong blockquote i b ul li],
          remove_empty_nodes: false,
          attributes: %w[href src alt],
          debug: true,
          min_image_height: 200,
          min_image_width: 200
        ).content

        content_with_fixed_links = relative_to_absolute(base_uri, readable_content)

        # update table with contents
        update(content: content_with_fixed_links)

      rescue StandardError => e
        Rails.logger.warn "Error while extracting readable content: #{e}"
        # Write 'error' into content column, so we can tell between fetching and failed states
        update(content: 'error')
      end
    end
  end

  def submit_to_internet_archive
    Thread.new do
      Rails.application.executor.wrap do
        source_uri = Addressable::URI.parse(url)
        res = Net::HTTP.post_form(IA_API_URI, url: source_uri, capture_all: 'on')
      rescue StandardError => e
        Rails.logger.warn "Error while submitting to internet archive: #{e}"
      end
    end
  end
end
