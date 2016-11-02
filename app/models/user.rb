class User < ApplicationRecord
  include Securable

  USERNAME_FORMAT = /[a-zA-Z0-9\-\_]{6,25}/
  EMAIL_FORMAT = /[\w\+\-\.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+/

  USERNAME_FORMAT_REGEXP = /\A#{ USERNAME_FORMAT.source }\z/
  EAMIL_FORMAT_REGEXP = /\A#{ EMAIL_FORMAT.source }\z/i

  TIPS_USERNAME_FORMAT_MSG = 'USERNAME_FORMAT'

  validates :username, :email, :password, presence: true
  validates :username, length: { in: 6..25 },
                       format: { with: USERNAME_FORMAT_REGEXP, message: TIPS_USERNAME_FORMAT_MSG },
                       uniqueness: { case_sensitive: false }
  validates :email,    length: { maximum: 255 },
                       format: { with: EAMIL_FORMAT_REGEXP },
                       uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 },
                       allow_nil: true

  # 需引入gem bcrypt
  has_secure_password

  before_save :downcase_username_and_email

  attr_accessor :remember_token


  # 生成remember_me的加密字段digest, 并保留token
  def new_remember_digest
    @remember_token = new_token
    update_digest :remember, digest_token(remember_token)
  end

  def del_remember_digest
    @remember_token = nil
    update_digest :remember, nil
  end

  private
  def downcase_username_and_email
    username.downcase!
    email.downcase!
  end
end
