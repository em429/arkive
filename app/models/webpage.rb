class Webpage < ApplicationRecord
  belongs_to :user
  
  validates :url, presence: true, url: true,
                  uniqueness: { scope: :user_id, message: 'already in archive' }
  validates :user_id, presence: true

  enum :status, [ :unread, :started, :read ], default: :unread, prefix: true, scopes: true
  
  scope :ordered, -> { order(id: :desc) }
  scope :recent, ->(max=5) { limit(max) }

  default_scope { ordered }

  IA_GET_API = 'https://web.archive.org/web'

  before_create -> { self.internet_archive_url = "#{IA_GET_API}/#{url}" }

  def reading_time
    words_per_minute = 230
    begin
      text = Nokogiri::HTML(content).at('body').inner_text
      (text.scan(/\w+/).length / words_per_minute).to_i
    rescue NoMethodError
      '?'
    end
  end

  def title_missing?
    title.blank?
  end

end
