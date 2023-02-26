class User < ApplicationRecord
  ## Settings
  ###########
  has_secure_password

  ## Relations
  ############
  has_many :webpages, dependent: :destroy
  
  ## Callbacks
  ############
  before_save do
    self.email = email.downcase
    self.username = username.downcase
    set_slug
  end
  

  ## Validations
  ##############
  validates :username, uniqueness: true, presence: true, length: { maximum: 14 }
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
  /x
  validates :password, format: {
    with: PASSWORD_REQUIREMENTS,
    message: 'must be 8+ characters, and must include at least a number.'
  }
  
  def to_param
    slug
  end

  private

  def set_slug
    self.slug = self.username.parameterize
  end

end
