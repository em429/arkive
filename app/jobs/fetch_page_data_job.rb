class FetchPageDataJob < ApplicationJob
  queue_as :default
  
  # TODO move this constant global, as it repeats between jobs
  IA_GET_API = 'https://web.archive.org/web'

  def fetch_title(webpage)
    Net::HTTP.get(URI(webpage.url)).scan(%r{<title>(.*?)</title>})[0][0].force_encoding('UTF-8')
    rescue StandardError => e
      Rails.logger.warn "Error while fetching title: #{e}"
      "Got an error while fetching the title, please set it manually"
      # TODO: implement Kaya's equation to generate a title without request
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

  def fetch_readable_content(webpage, from_archive=false)
    source_uri = Addressable::URI.parse(webpage.url)
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
      min_image_width: 200
      # encoding: 'utf-8',
      # do_not_guess_encoding: true
    ).content

    # fix links
    content_with_fixed_links = relative_to_absolute(base_uri, readable_content)

  rescue StandardError => e
    Rails.logger.warn "Error while extracting readable content: #{e}"
    # Write 'error' into content column, so we can tell between fetching and failed states
  end
  
  def perform(webpage, from_archive=false)
    webpage.update(
      content: fetch_readable_content(webpage, from_archove=from_archive),
      title: fetch_title(webpage)
    )
  end
  
end
