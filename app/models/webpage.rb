class Webpage < ApplicationRecord
  belongs_to :user
  validates :url, presence: true, url: true,
                  uniqueness: { scope: :user_id, message: 'Webpage already in archive' }
  validates :user_id, presence: true
  scope :ordered, -> { order(id: :desc) }

  before_create -> { self.internet_archive_url = "#{IA_GET_API}/#{url}" }
  before_create :fetch_title, if: :title_missing?
  before_create :submit_to_internet_archive
  before_create -> { fetch_readable_content(from_archive: false) }
  

  # after_rollback, :retry_content_fetch, on: :create

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

  IA_SAVE_API = 'https://web.archive.org/save'
  IA_GET_API = 'https://web.archive.org/web'
  IA_AVAILABILITY_API = 'https://archive.org/wayback/available?url='

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
          base_uri = IA_GET_API
        else
          source = URI.open(source_uri).read
          base_uri = source_uri.site
        end

        # source = source.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_')
        readable_content = Readability::Document.new(
          source,
          tags: %w[div h1 h2 h3 h4 h5 h6 h7 p a pre img figure strong blockquote i b ul li],
          remove_empty_nodes: false,
          attributes: %w[href src alt],
          debug: true,
          min_image_height: 200,
          min_image_width: 200,
          # encoding: 'utf-8',
          # do_not_guess_encoding: true
        ).content

        content_with_fixed_links = relative_to_absolute(base_uri, readable_content)

        # update table with contents
        # self.content = content_with_fixed_links
        update(content: content_with_fixed_links)

      rescue StandardError => e
        Rails.logger.warn "Error while extracting readable content: #{e}"
        # Write 'error' into content column, so we can tell between fetching and failed states
      end
    end
  end

  def submit_to_internet_archive
    Thread.new do
      Rails.application.executor.wrap do
        source_uri = Addressable::URI.parse(url)
        submit_res = Net::HTTP.post_form(URI(IA_SAVE_API), url: source_uri, capture_all: 'on')

       available_snapshots = JSON.parse(Net::HTTP.get(URI("#{IA_AVAILABILITY_API}#{url}")))
       # TODO: - if fetch_title succeeds (site status check) then keep retrying with delays
       #       - if fetch_title failed, and site is not coming back as available from IA, don't retry

       if available_snapshots["archived_snapshots"].empty?
         Rails.logger.debug "NO Snapshots available! --> #{available_snapshots.inspect}"
       else
         Rails.logger.debug "Snapshots available! --> #{available_snapshots.inspect}"
       end
        
      rescue StandardError => e
        Rails.logger.warn "Error while submitting to internet archive: #{e}"
      end
    end
  end
end
