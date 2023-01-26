class SubmitToInternetArchiveJob < ApplicationJob
  queue_as :default
  
  IA_SAVE_API = 'https://web.archive.org/save'
  IA_GET_API = 'https://web.archive.org/web'
  IA_AVAILABILITY_API = 'https://archive.org/wayback/available?url='

  def perform(webpage)
    source_uri = Addressable::URI.parse(webpage.url)
    submit_res = Net::HTTP.post_form(URI(IA_SAVE_API), url: source_uri, capture_all: 'on')

    available_snapshots = JSON.parse(Net::HTTP.get(URI("#{IA_AVAILABILITY_API}#{webpage.url}")))
    # TODO: - if fetch_title succeeds (site status check) then keep retrying with delays
    #       - if fetch_title failed, and site is not coming back as available from IA, don't retry

    if available_snapshots['archived_snapshots'].empty?
      Rails.logger.debug "NO Snapshots available! --> #{available_snapshots.inspect}"
    else
      Rails.logger.debug "Snapshots available! --> #{available_snapshots.inspect}"
    end
  rescue StandardError => e
    Rails.logger.warn "Error while submitting to internet archive: #{e}"
  end
end
