class Webpage < ApplicationRecord
  belongs_to :user
  validates :url, presence: true, url: true,
                  uniqueness: { scope: :user_id, message: 'Webpage already in archive' }
  validates :user_id, presence: true
  scope :ordered, -> { order(id: :desc) }

  IA_GET_API = 'https://web.archive.org/web'

  before_create -> { self.url_md5_hash = Digest::MD5.hexdigest(url) }
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

  # Overwrite parent ActiveRecord to_param method
  #   (it returns the :id by default)
  def to_param
    url_md5_hash
  end

end
