class Webpage < ApplicationRecord

  belongs_to :user

  before_validation :add_url_protocol_if_missing

  validates :url, presence: true, url: true,
                  uniqueness: { scope: :user_id, message: 'already in archive' }
  validates :user_id, presence: true

  enum :status, [ :unread, :started, :read ], default: :unread, prefix: true, scopes: true
  
  scope :ordered, -> { order(id: :desc) }
  scope :recent, ->(max=5) { limit(max) }

  default_scope { ordered }

  before_create -> { self.internet_archive_url = "#{IA_GET_API}/#{url}" }

  # TODO: extract to lib / model
  def reading_time
    words_per_minute = 230
    text = Nokogiri::HTML(content).at('body').inner_text
    length_in_minutes = (text.scan(/\w+/).length / words_per_minute).to_i

    if length_in_minutes < 1
      " < 1"
    else
      length_in_minutes.to_s
    end

    rescue NoMethodError
      '?'
  end

  private
  
  def add_url_protocol_if_missing
    unless url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]
      self.url = "http://#{url}"
    end
  end
  

end
