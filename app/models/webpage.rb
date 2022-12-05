class Webpage < ApplicationRecord
  belongs_to :user
  validates :url, presence: true, length: { minimum: 3 }, url: true,
                  uniqueness: { scope: :user_id, message: 'Webpage already in archive' }
  validates :user_id, presence: true
  scope :ordered, -> { order(id: :desc) }

  after_create_commit :fetch_title, if: :title_missing?
  after_create_commit :submit_to_internet_archive
  # if: Proc.new { self.content.blank? }

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
        # Save to Internet Archive
        ia_api_uri = URI('https://web.archive.org/save')
        res = Net::HTTP.post_form(ia_api_uri, url: url, capture_all: 'on')
        raise 'ArchiveFailedException' if res.nil?

        # TODO: how to recover if response times out or errors?
        #       - put into retry queue that gets retried every 10m?

        # Extract primary readable content and add it to db
        source = URI.parse("https://web.archive.org/web/#{url}").open.read

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
        # Regex below matches all strings starting with '/web/' and inserts IA's url in front
        # TODO: fix the relative link fixing
        content_with_fixed_links = readable_content.gsub(%r{^/web/}, 'https://web.archive.org')
        update(content: content_with_fixed_links)
      end
    end
  end
end
