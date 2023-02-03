class User < ApplicationRecord
  ## Settings
  ###########
  has_secure_password
  extend FriendlyId
  friendly_id :name, use: :slugged

  ## Relations
  ############
  has_many :webpages, dependent: :destroy
  
  ## Callbacks
  ############
  before_save do
    self.email = email.downcase
    self.name = name.downcase
  end
  

  ## Validations
  ##############
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  # For symbols:
  #  (?=.*[[:^alnum:]]) # At least on symbol
  PASSWORD_REQUIREMENTS = /\A
    (?=.{8,}) # At least 8 characters long
    (?=.*\d) # At least one number
    (?=.*[a-z]) # At least one lowercase
    (?=.*[A-Z]) # At least one uppercase
  /x
  validates :password, format: {
    with: PASSWORD_REQUIREMENTS,
    message: 'must be 8+ characters, and must include: number, lowercase and uppercase letters.'
  }
  

  private

end
