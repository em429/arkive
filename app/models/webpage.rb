class Webpage < ApplicationRecord
  validates :url, presence: true, length: { minimum: 3 }
end
