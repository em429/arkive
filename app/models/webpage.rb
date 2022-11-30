class Webpage < ApplicationRecord
  validates :url, presence: true, length: { minimum: 3 }, url: true
  scope :ordered, -> { order(id: :desc) }


  # methods
  #

  def reading_time
    words_per_minute = 230
    begin
      text = Nokogiri::HTML(self.content).at('body').inner_text
      (text.scan(/\w+/).length / words_per_minute).to_i
    rescue NoMethodError
      "?"
    end
  end
end
